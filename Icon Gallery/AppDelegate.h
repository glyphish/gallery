//
//  BFAppDelegate.h
//  Icon Gallery
//
//  Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@import Quartz.ImageKit;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet IKImageBrowserView *iconBrowserView;
@property (weak) IBOutlet IKImageBrowserView *selectedIconBrowserView;
@property (weak) IBOutlet NSPathControl *pathControl;
@property (weak) IBOutlet NSDrawer *drawer;

- (IBAction)pickSourceFolder:(id)sender;
@end
