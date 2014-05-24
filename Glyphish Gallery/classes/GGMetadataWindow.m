//
//  GGMetadataWindow.m
//  Glyphish Gallery
//
//  Created by Rudd Fawcett on 5/21/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "GGMetadataWindow.h"

@interface GGMetadataWindow ()

@property (strong, readwrite, nonatomic) NSMutableArray *metadataList;

@end

@implementation GGMetadataWindow

- (void)makeKeyAndOrderFront:(id)sender {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsColumnSelection = NO;
    self.tableView.allowsMultipleSelection = NO;
    // self.tableView.allowsEmptySelection = NO;
    [self.tableView sizeLastColumnToFit];
    
    self.metadataList = [self metadataFiles];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"fileChanged" object:nil];
    
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    
    if (menuItem.tag == 0) {
        [self.tabView selectTabViewItemWithIdentifier:@"import"];
    }
    else if (menuItem.tag == 1) {
        [self.tabView selectTabViewItemWithIdentifier:@"manage"];
    }
    
    [super makeKeyAndOrderFront:sender];
}

- (void)reloadData {
    self.metadataList = [self metadataFiles];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)metadataFiles {
    NSURL *applicationSupport = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSString *selfName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    
    NSString *importedMetadataPath = [applicationSupport.path stringByAppendingPathComponent:selfName];
    
    NSMutableArray *directoryContents = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:importedMetadataPath error:nil] mutableCopy];
    
    [directoryContents removeObject:@".DS_Store"];
    
    NSMutableArray *fixedPaths = [NSMutableArray new];
    
    for (NSString *fileName in directoryContents) {
        NSString *newPath = [[applicationSupport.path stringByAppendingPathComponent:selfName] stringByAppendingPathComponent:fileName];

        [fixedPaths addObject:newPath];
    }
    
    return fixedPaths;
}

- (void)keyDown:(NSEvent *)event {
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    
    if (key == NSDeleteCharacter) {
        if (self.tableView.selectedRow != -1) {
            NSInteger index = self.tableView.selectedRow;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self.metadataList objectAtIndex:index] isDirectory:NO]) {
                [[NSFileManager defaultManager] removeItemAtPath:[self.metadataList objectAtIndex:index] error:nil];
                
                NSNotification *notification = [NSNotification notificationWithName:@"fileChanged" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            
            [self reloadData];
        }
        else {
            NSBeep();
        }
    }
    
    [super keyDown:event];
}

# pragma mark NSTableView Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.metadataList.count;
}

- (NSInteger)numberOfColumns {
    return 1;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColum row:(NSInteger)rowIndex {
    NSString *fileName = [[self.metadataList objectAtIndex:rowIndex] lastPathComponent];
    
    return fileName;
}

@end
