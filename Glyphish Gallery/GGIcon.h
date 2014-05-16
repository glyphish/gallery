//
//  Icon.h
//  Icon Gallery
//
//  Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//
//  Since the above copyrighted date, these files, and others in this project
//  may have been edited or created by a non copyright holder.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface GGIcon : NSObject

@property (strong, readwrite, nonatomic) NSString       *title;
@property (strong, readwrite, nonatomic) NSString       *basePath;
@property (strong, readwrite, nonatomic) NSString       *filePath;
@property (strong, readwrite, nonatomic) NSString       *iconName;
@property (strong, readwrite, nonatomic) NSString       *searchTitle;
@property (strong, readwrite, nonatomic) NSMutableArray *variants;
@property (readwrite, nonatomic)         BOOL           toolbarIcon;

@end
