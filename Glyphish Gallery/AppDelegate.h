//
//  AppDelegate.h
//  Icon Gallery
//
//  Originally Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//
//  Since the above copyrighted date, these files, and others in this project
//  may have been edited or created by a non copyright holder.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "GGIcon.h"
#import "GGMetadata.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign, readwrite)          IBOutlet NSWindow            *window;
@property (weak, readwrite, nonatomic) IBOutlet IKImageBrowserView  *iconBrowserView;
@property (weak, readwrite, nonatomic) IBOutlet IKImageBrowserView  *selectedIconBrowserView;
@property (weak, readwrite, nonatomic) IBOutlet NSPathControl       *pathControl;
@property (weak, readwrite, nonatomic) IBOutlet NSDrawer            *drawer;

- (IBAction)pickSourceFolder:(id)sender;

@end
