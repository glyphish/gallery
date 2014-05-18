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
    
    NSURL *applicationSupport = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSString *selfName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    
    NSString *importedMetadataPath = [applicationSupport.path stringByAppendingPathComponent:selfName];
    
    glyphishMetadatas = [glyphishMetadatas arrayByAddingObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:importedMetadataPath error:nil]];
    
    NSMutableDictionary *totalMetadata = [NSMutableDictionary new];
    
    int index = 0;
    
    for (NSString *fileName in glyphishMetadatas) {
//        NSArray *glyphishCheck = [fileName componentsSeparatedByString:@"-"];
//         && [[glyphishCheck objectAtIndex:0] isEqualToString:@"glyphish"]
        
        if ([[fileName pathExtension] isEqualToString:@"gmetadata"] || [[fileName pathExtension] isEqualToString:@"json"]) {
            NSString *file;
            
            if ([[fileName pathExtension] isEqualToString:@"gmetadata"]) {
                file = [metadataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
            }
            else if ([[fileName pathExtension] isEqualToString:@"json"]) {
                file = [importedMetadataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
            }
            
            NSData *jsonFile = [NSData dataWithContentsOfFile:file];
            NSMutableDictionary *metadata = [NSJSONSerialization JSONObjectWithData:jsonFile options:kNilOptions error:nil];
            
            if (index == 0) {
                [totalMetadata addEntriesFromDictionary:metadata];
            }
            else {
                for (NSString *iconName in [metadata allKeys]) {
                    if ([totalMetadata objectForKey:iconName]) {
                        NSMutableSet *set = [NSMutableSet setWithArray:[totalMetadata objectForKey:iconName]];
                        
                        [set addObjectsFromArray:[metadata objectForKey:iconName]];
                        [totalMetadata setObject:[set allObjects] forKey:iconName];
                    }
                    else {
                        [totalMetadata setObject:[metadata objectForKey:iconName] forKey:iconName];
                    }
                }
            }
        }
        
        index++;
    }
    
    
    return totalMetadata;
}

@end
