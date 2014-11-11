//
//  AppDelegate.m
//  Icon Gallery
//
//  Originally Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//
//  Since the above copyright date, these files, and others in this project
//  may have been edited or created by a non copyright holder.
//

#import "AppDelegate.h"

#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

const CGFloat kGGFuzzySearchMatchFloor = 0.4;

@interface AppDelegate ()

@property (strong, readwrite, nonatomic) NSURL               *sourceFolderURL;
@property (strong, readwrite, nonatomic) NSURL               *importJSONURL;
@property (strong, readwrite, nonatomic) NSString            *fileExtension;
@property (strong, readwrite, nonatomic) NSArray             *iconsArray;
@property (strong, readwrite, nonatomic) NSArray             *allIconsArray;
@property (strong, readwrite, nonatomic) GGIcon              *selectedIcon;
@property (strong, readwrite, nonatomic) NSURL               *selectedURL;
@property (strong, readwrite, nonatomic) NSMutableDictionary *pngIcons;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [DDLog addLogger: DDASLLogger.sharedInstance];
    [DDLog addLogger: DDTTYLogger.sharedInstance];
    
    DDTTYLogger.sharedInstance.colorsEnabled =YES;
    
    self.window.minSize = CGSizeMake(245, 200);
    
    [self.fileType setAction:@selector(segmentZeroAction) forSegment:0];
    [self.fileType setAction:@selector(segmentOneAction) forSegment:1];
    
    NSString *sourceFolderPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"sourceFolderPath"];
    if (sourceFolderPath != nil) {
        self.sourceFolderURL = [NSURL fileURLWithPath:sourceFolderPath];
    }
    
    [self.pathControl setAction:@selector(pathControlClicked)];
    
    [self initializeIconBrowser];
    [self initializeSelectedIconBrowser];
    
    if (!self.sourceFolderURL) {
        [self pickSourceFolder:nil];
    } else {
        self.fileExtension = @"png";
        [self scanURLIgnoringExtras:self.sourceFolderURL];
    }
}

- (void)segmentZeroAction {
    self.fileExtension = @"png";
    [self scanURLIgnoringExtras:self.sourceFolderURL];
}

- (void)segmentOneAction {
    self.fileExtension = @"svg";
    [self scanURLIgnoringExtras:self.sourceFolderURL];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}

- (void)initializeIconBrowser {
    self.iconBrowserView.delegate = self;
    self.iconBrowserView.dataSource = self;
    self.iconBrowserView.constrainsToOriginalSize = YES;
    self.iconBrowserView.cellsStyleMask = IKCellsStyleTitled;
    
    [self.iconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor grayColor]} forKey:IKImageBrowserCellsTitleAttributesKey];
    [self.iconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor whiteColor]} forKey:IKImageBrowserCellsHighlightedTitleAttributesKey];
}
- (void)initializeSelectedIconBrowser {
    self.selectedIconBrowserView.delegate = self;
    self.selectedIconBrowserView.dataSource = self;
    self.selectedIconBrowserView.constrainsToOriginalSize = YES;
    self.selectedIconBrowserView.cellsStyleMask = IKCellsStyleTitled;
    
    [self.selectedIconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor grayColor]} forKey:IKImageBrowserCellsTitleAttributesKey];
    [self.selectedIconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor whiteColor]} forKey:IKImageBrowserCellsHighlightedTitleAttributesKey];
}

- (void)pathControlClicked {
    if ([self.pathControl clickedPathComponentCell] != nil) {
        [[NSWorkspace sharedWorkspace] openURL:[[self.pathControl clickedPathComponentCell] URL]];
    }
}

- (IBAction)pickSourceFolder:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = NO;
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    panel.title = NSLocalizedString(@"Pick a folder containing your Glyphish icons.", nil);
    
    long result = [panel runModal];
    
    if (result == NSOKButton) {
        NSURL *url = panel.URL;
        
        [[NSUserDefaults standardUserDefaults] setValue:url.path forKey:@"sourceFolderPath"];
        
        self.sourceFolderURL = [NSURL fileURLWithPath:url.path];
        
        [self.preferencesWindow close];
        
        if (self.fileType.selectedSegment == 0) {
            self.fileExtension = @"png";
        }
        else self.fileExtension = @"svg";
        
        [self scanURLIgnoringExtras:url];
    }
}

-(void)scanURLIgnoringExtras:(NSURL *)directoryToScan {
    // Create a local file manager instance
    NSFileManager *localFileManager = [[NSFileManager alloc] init];
    
    // Enumerate the directory (specified elsewhere in your code)
    // Request the two properties the method uses, name and isDirectory
    // Ignore hidden files
    // The errorHandler: parameter is set to nil. Typically you'd want to present a panel
    NSDirectoryEnumerator *dirEnumerator = [localFileManager enumeratorAtURL:directoryToScan
                                                  includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:nil];
    
    // An array to store the all the enumerated file names in
    NSMutableArray *theArray = [NSMutableArray array];
    
    NSMutableDictionary *pngIcons = [NSMutableDictionary new];
    
    // Enumerate the dirEnumerator results, each value is stored in allURLs
    for (NSURL *theURL in dirEnumerator) {
        // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
        NSString *fileName;
        [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
        
        // Retrieve whether a directory. From NSURLIsDirectoryKey, also
        // cached during the enumeration.
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        // Ignore files under the _extras directory
        if (([fileName caseInsensitiveCompare:@"Small (toolbar)"] == NSOrderedSame) ||
            ([fileName caseInsensitiveCompare:@"Small"] == NSOrderedSame) ||
            ([fileName caseInsensitiveCompare:@"Small (tab bar)"] == NSOrderedSame)
            ) {
            if (([isDirectory boolValue]==YES)) {
                [dirEnumerator skipDescendants];
            }
        }
        else {
            // Add full path for non directories
            if ([isDirectory boolValue] == NO && [fileName.pathExtension isEqualToString:self.fileExtension]) {
                //  NSString *filename = [theURL.path.lastPathComponent stringByDeletingPathExtension];
                
                if (!(([[fileName stringByDeletingPathExtension] hasSuffix:@"@2x"]) ||
                      ([[fileName stringByDeletingPathExtension] hasSuffix:@"@3x"])   ) ){
                    GGIcon *anIcon = [[GGIcon alloc] init];
                    anIcon.basePath = theURL.path;
                    
                    fileName = [fileName stringByDeletingPathExtension];
                    fileName = [fileName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
                    fileName = [fileName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
                    
                    
                    if ([self.fileExtension isEqualToString:@"png"]) {
                        [pngIcons setObject:theURL.path forKey:fileName];
                    }
                    
                    
                    if ([self.fileExtension isEqualToString:@"svg"]) {
                        anIcon.svgIcon = YES;
                        anIcon.pngPath = [self.pngIcons objectForKey:fileName];
                    }
                    
                    [theArray addObject:anIcon];
                }
                
            }
        }
    }
    
    self.pngIcons = pngIcons;
    
    self.iconsArray = theArray;
    self.allIconsArray = theArray;
    
    [self.iconBrowserView reloadData];
}

- (IBAction)search:(id)sender {
    NSSearchField *searchField = (NSSearchField *)sender;
    NSString *searchString = [searchField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (searchString.length == 0) {
        self.iconsArray = self.allIconsArray;
        
        [self.iconBrowserView reloadData];
        
        return;
    }
    
    NSPredicate *substrPred = [NSPredicate predicateWithFormat:@"(SELF.title contains %@) OR (ANY SELF.tags contains %@)", searchString, searchString];
    NSArray *substrMatches = [self.allIconsArray filteredArrayUsingPredicate:substrPred];
    
    NSArray *fuzzyMatches = [self.allIconsArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        GGIcon *icon = (GGIcon*)evaluatedObject;
        
        // no matches yet? better try something fuzzy
        NSStringScoreOption fuzzyOptions = 0;// (NSStringScoreOptionFavorSmallerWords | NSStringScoreOptionReducedLongStringPenalty);
        CGFloat titleScore = [icon.title scoreAgainst:searchString
                                            fuzziness:@(0.5)
                                              options:fuzzyOptions];
        
        if(titleScore > kGGFuzzySearchMatchFloor) {
            return YES;
        }
        
        for(NSString *tag in icon.tags) {
            CGFloat tagScore = [tag scoreAgainst:searchString
                                       fuzziness:@(0.5)
                                         options:fuzzyOptions];
            
            if(tagScore > kGGFuzzySearchMatchFloor) {
                return YES;
            }
        }
        
        return NO;
    }]];
    
    self.iconsArray = [[substrMatches arrayByAddingObjectsFromArray:fuzzyMatches] valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    // display results in glyphish order (icon 1, icon 2, etc)
    self.iconsArray = [self.iconsArray sortedArrayUsingComparator:^NSComparisonResult(GGIcon *obj1, GGIcon *obj2) {
        return [obj1.title compare:obj2.title
                           options:(NSNumericSearch | NSCaseInsensitiveSearch)];
    }];
    
    [self.iconBrowserView reloadData];
}


#pragma mark - IKImageBrowser delegate

- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)browser; {
    NSUInteger index = [browser.selectionIndexes lastIndex];
    
    if (browser == self.iconBrowserView) {
        [self.drawer open];
        if (browser.selectionIndexes.count == 1) {
            self.selectedIcon = [self.iconsArray objectAtIndex:index];
            self.selectedURL = [NSURL fileURLWithPath:self.selectedIcon.filePath];
        } else {
            self.selectedIcon = nil;
            self.selectedURL = nil;
        }
        [self.selectedIconBrowserView reloadData];
    } else {
        if (browser.selectionIndexes.count == 1) {
            self.selectedURL = [NSURL fileURLWithPath:[[self.selectedIcon.variants objectAtIndex:index] filePath]];
        } else {
            self.selectedURL = nil;
        }
    }
}

- (void)imageBrowser:(IKImageBrowserView *)browser cellWasRightClickedAtIndex:(NSUInteger)index withEvent:(NSEvent *)event {
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Menu"];
    menu.autoenablesItems = NO;
    
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Copy", nil) action:@selector(copy:) keyEquivalent:@""];
    menuItem.representedObject = [self.iconsArray objectAtIndex:index];
    menuItem.target = self;
    
    [menu addItem:menuItem];
    
    menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Reveal in Finder", nil) action:@selector(revealInFinder:) keyEquivalent:@""];
    menuItem.representedObject = [self.iconsArray objectAtIndex:index];
    menuItem.target = self;
    
    [menu addItem:menuItem];
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:browser];
}

- (IBAction)copy:(id)sender {
    NSMenuItem *menuItem = sender;
    
    GGIcon *someIcon = menuItem.representedObject;
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:someIcon.filePath];
    
    if (image != nil) {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        
        [pasteboard clearContents];
        
        NSArray *copiedObjects = [NSArray arrayWithObject:image];
        
        [pasteboard writeObjects:copiedObjects];
    }
}

- (IBAction)revealInFinder:(id)sender {
    NSMenuItem *menuItem = sender;
    
    GGIcon *someIcon = menuItem.representedObject;
    
	[[NSWorkspace sharedWorkspace] selectFile:someIcon.filePath inFileViewerRootedAtPath: nil];
}

#pragma mark - IKImageBrowser data source

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)browser {
    if (self.iconsArray && browser == self.iconBrowserView) {
        return self.iconsArray.count;
    } else if (self.selectedIcon != nil) {
        return self.selectedIcon.variants.count; // each icon has for variants
    }
    return 0;
}

- (id)imageBrowser:(IKImageBrowserView *)browser itemAtIndex:(NSUInteger)index {
    id returnValue;
    
    if (browser == self.iconBrowserView) {
        returnValue = [self.iconsArray objectAtIndex:index];
    } else if (browser == self.selectedIconBrowserView) {
        returnValue = [self.selectedIcon.variants objectAtIndex:index];
    }
    
    return returnValue;
}

@end
