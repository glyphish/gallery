//
//  GGImportView.m
//  Glyphish Gallery
//
//  Created by Rudd Fawcett on 5/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "GGImportView.h"

@interface GGImportView ()

@property (strong, readwrite, nonatomic) NSURL  *importJSONURL;

@end

@implementation GGImportView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    // In case I decide to override drawRect...
    [self setNeedsDisplay:YES];
    return NSDragOperationGeneric;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender{
    // In case I decide to override drawRect...
    [self setNeedsDisplay:YES];
}


- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    // In case I decide to override drawRect...
    [self setNeedsDisplay:YES];
    return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    NSArray *draggedFiles = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    if ([[[draggedFiles objectAtIndex:0] pathExtension] isEqual:@"json"]){
        return YES;
    } else {
        return NO;
    }
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender{
    NSArray *draggedFiles = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];

    self.importJSONURL = [NSURL fileURLWithPath:[draggedFiles objectAtIndex:0]];
    
    [self importJSONMetadata];
}


- (void)importJSONMetadata {
    if (self.importJSONURL == nil) {
        return;
    }
    else {
        if ([[NSFileManager defaultManager] isReadableFileAtPath:self.importJSONURL.path]) {
            NSURL *applicationSupport = [[NSFileManager defaultManager]
                                         URLForDirectory:NSApplicationSupportDirectory
                                         inDomain:NSUserDomainMask
                                         appropriateForURL:nil
                                         create:YES
                                         error:nil];
            
            NSString *selfName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            
            NSString *copyPath = [applicationSupport.path stringByAppendingPathComponent:selfName];
            
            BOOL isDirectory = YES;
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:copyPath isDirectory:&isDirectory]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:copyPath
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil];
            }
            
            NSURL *copyURL = [NSURL fileURLWithPath:[copyPath stringByAppendingPathComponent:[self.importJSONURL.path lastPathComponent]]];
            
            NSError *error;
            
            NSURL *renamedFileURL;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:copyURL.path]) {
                NSString *folderName = [copyURL.path stringByDeletingLastPathComponent];
                NSString *fullFileName = [copyURL.path lastPathComponent];
                NSString *fileName = [fullFileName stringByDeletingPathExtension];
                NSString *ext = [copyURL.path pathExtension];
                
                int index = 1;
                while ([[NSFileManager defaultManager] fileExistsAtPath:[folderName stringByAppendingPathComponent:fullFileName]]) {
                    fullFileName = [NSString stringWithFormat:@"%@-%d.%@", fileName, index, ext];
                    
                    index++;
                }
                
                renamedFileURL = [NSURL fileURLWithPath:[folderName stringByAppendingPathComponent:fullFileName]];
            }
            else renamedFileURL = copyURL;
            
            if ([[NSFileManager defaultManager] copyItemAtURL:self.importJSONURL toURL:renamedFileURL error:&error]) {
                NSNotification *notification = [NSNotification notificationWithName:@"refreshMetadata" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }
    }
}
@end
