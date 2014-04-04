//
//  Icon.h
//  Icon Gallery
//
//  Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quartz.ImageKit;

@interface Icon : NSObject

@property NSString *title;
@property (nonatomic) NSString *basePath;
@property NSString *filePath;
@property NSMutableArray *variants;

@end
