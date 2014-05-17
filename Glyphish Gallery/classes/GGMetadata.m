//
//  GGMetadata.m
//  Glyphish Gallery
//
//  Created by Rudd Fawcett on 5/16/14.
//  Copyright (c) 2014 Rudd Fawcett All rights reserved.
//

#import "GGMetadata.h"

@implementation GGMetadata

+ (NSMutableDictionary *)combinedMetadata {
    NSString *metadataPath = [[NSBundle mainBundle] resourcePath];
    metadataPath = [metadataPath stringByAppendingPathComponent:@"metadata"];
    NSArray *glyphishMetadatas = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:metadataPath error:nil];
    
    NSMutableDictionary *totalMetadata = [NSMutableDictionary new];
    
    for (NSString *fileName in glyphishMetadatas) {
        NSArray *glyphishCheck = [fileName componentsSeparatedByString:@"-"];
        
        if ([[fileName pathExtension] isEqualToString:@"json"] && [[glyphishCheck objectAtIndex:0] isEqualToString:@"glyphish"]) {
            NSString *filePath = [NSString stringWithFormat:@"/%@",fileName];
            
            NSData *jsonFile = [NSData dataWithContentsOfFile:[metadataPath stringByAppendingPathComponent:filePath]];
            
            NSDictionary *metadata = [NSJSONSerialization JSONObjectWithData:jsonFile options:kNilOptions error:nil];;
            
            [totalMetadata addEntriesFromDictionary:metadata];
        }
    }
    
    return totalMetadata;
}

@end
