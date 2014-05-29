//
//  GGIcon.h
//  Icon Gallery
//
//  Originally Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//
//  Since the above copyright date, these files, and others in this project
//  may have been edited or created by a non copyright holder.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface GGIcon : NSObject

@property (nonatomic)           NSString       *title;
@property (nonatomic)           NSString       *basePath;
@property (nonatomic)           NSString       *filePath;
@property (nonatomic)           NSString       *pngPath;
@property (nonatomic)           NSString       *iconName;
@property (nonatomic)           NSString       *searchTitle;
@property (nonatomic)           NSMutableArray *variants;
@property (nonatomic)           BOOL            svgIcon;
@property (nonatomic, readonly) NSArray        *tags;

@end
