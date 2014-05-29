//
//  GGMetadata.h
//  Glyphish Gallery
//
//  Created by Rudd Fawcett on 5/16/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGMetadata : NSObject

@property (nonatomic, readonly) NSDictionary *combinedMetadata;

+ (instancetype)sharedInstance;

@end
