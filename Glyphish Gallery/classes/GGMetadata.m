//
//  GGMetadata.m
//  Glyphish Gallery
//
//  Created by Rudd Fawcett on 5/16/14.
//  Copyright (c) 2014 Rudd Fawcett All rights reserved.
//

#import "GGMetadata.h"

@implementation GGMetadata

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self.alloc init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        [self initializeMetadata];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initializeMetadata)
                                                     name:@"fileChanged"
                                                   object:nil];

    }
    
    return self;
}

- (NSDictionary *)initializeMetadata {
    NSString *metadataPath = NSBundle.mainBundle.resourcePath;
    metadataPath = [metadataPath stringByAppendingPathComponent:@"metadata.bundle/Contents/Resources"];
    
    NSArray *glyphishMetadatas = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:metadataPath
                                                                                     error:nil];
    NSURL *applicationSupport = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:nil];
    
    NSString *selfName = NSBundle.mainBundle.infoDictionary[@"CFBundleName"];
    NSString *importedMetadataPath = [applicationSupport.path stringByAppendingPathComponent:selfName];
    
    NSArray *dirContents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:importedMetadataPath
                                                                             error:nil];
    
    glyphishMetadatas = [glyphishMetadatas arrayByAddingObjectsFromArray:dirContents];
    
    NSMutableDictionary *totalMetadata = NSMutableDictionary.new;
    
    int index = 0;
    
    for (NSString *fileName in glyphishMetadatas) {
        if([fileName.pathExtension isEqualToString:@"gmetadata"]
        || [fileName.pathExtension isEqualToString:@"json"]) {
            NSString *file;
            
            if ([fileName.pathExtension isEqualToString:@"gmetadata"]) {
                file = [metadataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
            }
            else if ([fileName.pathExtension isEqualToString:@"json"]) {
                file = [importedMetadataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
            }
            
            NSData *jsonFile = [NSData dataWithContentsOfFile:file];
            NSMutableDictionary *metadata = [NSJSONSerialization JSONObjectWithData:jsonFile
                                                                            options:kNilOptions
                                                                              error:nil];
            
            if (index == 0) {
                [totalMetadata addEntriesFromDictionary:metadata];
            }
            else {
                for (NSString *iconName in metadata.allKeys) {
                    if (totalMetadata[iconName]) {
                        NSMutableSet *set = [NSMutableSet setWithArray:totalMetadata[iconName]];
                        
                        [set addObjectsFromArray:metadata[iconName]];
                        [totalMetadata setObject:set.allObjects
                                          forKey:iconName];
                    }
                    else {
                        [totalMetadata setObject:metadata[iconName]
                                          forKey:iconName];
                    }
                }
            }
        }
        
        index++;
    }
    
    _combinedMetadata = totalMetadata;
    
    return totalMetadata;
}

@end
