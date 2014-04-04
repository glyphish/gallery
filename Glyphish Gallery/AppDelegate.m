//
//  BFAppDelegate.m
//  Icon Gallery
//
//  Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//

#import "AppDelegate.h"
#import "Icon.h"

@interface AppDelegate ()

@property NSURL *sourceFolderURL;
@property NSArray *iconsArray;
@property NSArray *allIconsArray;
@property Icon *selectedIcon;
@property NSURL *selectedURL;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *sourceFolderPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"sourceFolderPath"];
    if (sourceFolderPath != nil) {
        self.sourceFolderURL = [NSURL fileURLWithPath:sourceFolderPath];
    }
    
    [self.pathControl setAction:@selector(pathControlClicked)];
    
    self.iconBrowserView.delegate = self;
    self.iconBrowserView.dataSource = self;
    self.iconBrowserView.constrainsToOriginalSize = YES;
    self.iconBrowserView.cellsStyleMask = IKCellsStyleTitled;
    
    [self.iconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor grayColor]} forKey:IKImageBrowserCellsTitleAttributesKey];
    [self.iconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor whiteColor]} forKey:IKImageBrowserCellsHighlightedTitleAttributesKey];
    
    self.selectedIconBrowserView.delegate = self;
    self.selectedIconBrowserView.dataSource = self;
    self.selectedIconBrowserView.constrainsToOriginalSize = YES;
    self.selectedIconBrowserView.cellsStyleMask = IKCellsStyleTitled;
    
    [self.selectedIconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor grayColor]} forKey:IKImageBrowserCellsTitleAttributesKey];
    [self.selectedIconBrowserView setValue:@{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName : [NSColor whiteColor]} forKey:IKImageBrowserCellsHighlightedTitleAttributesKey];
    
    // Insert code here to initialize your application
    if (!self.sourceFolderURL) {
        [self pickSourceFolder:nil];
    } else {
        [self scanURLIgnoringExtras:self.sourceFolderURL];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)pathControlClicked
{
    if ([self.pathControl clickedPathComponentCell] != nil) {
        [[NSWorkspace sharedWorkspace] openURL:[[self.pathControl clickedPathComponentCell] URL]];
    }
}

- (IBAction)pickSourceFolder:(id)sender;
{
    NSOpenPanel		*panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setTitle:NSLocalizedString(@"Pick a folder containing your Glyphish icons", nil)];
    
    long result = [panel runModal];
    
    // export
    if (result == NSOKButton)
    {
        NSURL *url = [panel URL];
        
        [[NSUserDefaults standardUserDefaults] setValue:url.path forKey:@"sourceFolderPath"];
        self.sourceFolderURL = [NSURL fileURLWithPath:url.path];
        
        [self scanURLIgnoringExtras:url];
    }
}

-(void)scanURLIgnoringExtras:(NSURL *)directoryToScan
{
    // Create a local file manager instance
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
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
        if (([fileName caseInsensitiveCompare:@"ressources"] == NSOrderedSame) ||
            ([fileName caseInsensitiveCompare:@"white"] == NSOrderedSame) ||
            ([fileName caseInsensitiveCompare:@"white selected"] == NSOrderedSame) ||
            ([fileName caseInsensitiveCompare:@"gray selected"] == NSOrderedSame)
            )
        {
            if (([isDirectory boolValue]==YES)) {
                [dirEnumerator skipDescendants];
            }
        }
        else
        {
            // Add full path for non directories
            if ([isDirectory boolValue] == NO && [fileName.pathExtension isEqualToString:@"png"]) {
              //  NSString *filename = [theURL.path.lastPathComponent stringByDeletingPathExtension];
                if (![[fileName stringByDeletingPathExtension] hasSuffix:@"@2x"]) {
                    Icon *anIcon = [[Icon alloc] init];
                    anIcon.basePath = theURL.path;
                    [theArray addObject:anIcon];
                }
            }
        }
    }
    
    self.iconsArray = theArray;
    self.allIconsArray = theArray;
    
    [self.iconBrowserView reloadData];
    
    // Do something with the path URLs.
 //   NSLog(@"theArray - %@",theArray);
}

- (IBAction)search:(id)sender
{
    NSSearchField *searchField = (NSSearchField *)sender;
    
    NSLog(@"Search: %@", searchField.stringValue);
    
    if (searchField.stringValue.length == 0) {
        self.iconsArray = self.allIconsArray;
        [self.iconBrowserView reloadData];
        return;
    }
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"title CONTAINS %@", searchField.stringValue];
    self.iconsArray = [self.allIconsArray filteredArrayUsingPredicate:p];
    [self.iconBrowserView reloadData];
}

#pragma mark - IKImageBrowser delegate

- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)browser;
{
    NSUInteger idx = [browser.selectionIndexes lastIndex];
        
    if (browser == self.iconBrowserView) {
        [self.drawer open];
         if (browser.selectionIndexes.count == 1) {
             self.selectedIcon = self.iconsArray[idx];
             self.selectedURL = [NSURL fileURLWithPath:self.selectedIcon.filePath];
         } else {
             self.selectedIcon = nil;
             self.selectedURL = nil;
         }
        [self.selectedIconBrowserView reloadData];
    } else {
        if (browser.selectionIndexes.count == 1) {
            self.selectedURL = [NSURL fileURLWithPath:[self.selectedIcon.variants[idx] filePath]];
        } else {
            self.selectedURL = nil;
        }
    }
}

- (void)imageBrowser:(IKImageBrowserView *)browser cellWasRightClickedAtIndex:(NSUInteger)index withEvent:(NSEvent *)event
{
    //contextual menu for item index
    NSMenu*  menu;
    
    menu = [[NSMenu alloc] initWithTitle:@"menu"];
    [menu setAutoenablesItems:NO];
    
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Copy", nil) action:@selector(copy:) keyEquivalent:@""];
    [menuItem setRepresentedObject:self.iconsArray[index]];
    [menuItem setTarget:self];
    [menu addItem:menuItem];
    menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Reveal in Finder", nil) action:@selector(revealInFinder:) keyEquivalent:@""];
    [menuItem setRepresentedObject:self.iconsArray[index]];
    [menuItem setTarget:self];
    [menu addItem:menuItem];
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:browser];
}

- (IBAction)copy:(id)sender
{
    NSMenuItem *menuItem = sender;
    
    Icon *someIcon = menuItem.representedObject;
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:someIcon.filePath];
    
    if (image != nil) {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        NSArray *copiedObjects = [NSArray arrayWithObject:image];
        [pasteboard writeObjects:copiedObjects];
    }
}

- (IBAction)revealInFinder:(id)sender
{
    NSMenuItem *menuItem = sender;
    
    Icon *someIcon = menuItem.representedObject;
    
	[[NSWorkspace sharedWorkspace] selectFile:someIcon.filePath inFileViewerRootedAtPath: nil];
}

#pragma mark - IKImageBrowser data source

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)browser
{
    if (self.iconsArray && browser == self.iconBrowserView) {
        return self.iconsArray.count;
    } else if (self.selectedIcon != nil) {
        return self.selectedIcon.variants.count; // each icon has for variants
    }
    return 0;
}

- (id)imageBrowser:(IKImageBrowserView *)browser itemAtIndex:(NSUInteger)index
{
    id returnValue;
    
    if (browser == self.iconBrowserView) {
        returnValue = self.iconsArray[index];
    } else if (browser == self.selectedIconBrowserView) {
        returnValue = self.selectedIcon.variants[index];
    }
    
    return returnValue;
}

@end
