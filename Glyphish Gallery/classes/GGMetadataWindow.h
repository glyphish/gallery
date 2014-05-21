//
//  GGMetadataWindow.h
//  Glyphish Gallery
//
//  Created by Rudd Fawcett on 5/21/14.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GGMetadataWindow : NSWindow <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@end
