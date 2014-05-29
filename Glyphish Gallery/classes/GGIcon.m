//
//  GGIcon.m
//  Icon Gallery
//
//  Originally Created by Jörgen Isaksson on 2014-03-16.
//  Copyright (c) 2014 Bitfield AB. All rights reserved.
//
//  Since the above copyright date, these files, and others in this project
//  may have been edited or created by a non copyright holder.
//

#import "GGIcon.h"

#import "GGMetadata.h"

@implementation GGIcon

#pragma mark - Extras

- (instancetype)init {
    self = [super init];
    if (self) {
        self.variants = [NSMutableArray array];
        self.title = nil;
    }
    
    return self;
}

- (void)setBasePath:(NSString *)aBasePath {
    _basePath = aBasePath;
    _filePath = aBasePath;
    
    self.iconName = [self.filePath.lastPathComponent stringByDeletingPathExtension];
    
    // check for variants
    NSString *base = [aBasePath stringByDeletingPathExtension];
    NSString *baseFolder = [base stringByDeletingLastPathComponent];
    NSString *selectedFolder = [NSString stringWithFormat:@"%@ Selected", baseFolder];
        
    NSString *selectedBase = [[selectedFolder stringByAppendingPathComponent:[base lastPathComponent]] stringByDeletingPathExtension];
    NSString *baseRetina = [[NSString stringWithFormat:@"%@@2x", base] stringByAppendingPathExtension:[aBasePath pathExtension]];
    
    NSString *selectedPath = [[NSString stringWithFormat:@"%@-selected", selectedBase] stringByAppendingPathExtension:[aBasePath pathExtension]];
    NSString *selectedRetinaPath = [[NSString stringWithFormat:@"%@-selected@2x", selectedBase] stringByAppendingPathExtension:[aBasePath pathExtension]];
    
    [self.variants removeAllObjects];
    
    NSString *title = [self.filePath.lastPathComponent stringByDeletingPathExtension];
    
    /* Used to see if the icon is a toolbar icon... Not used.
         if ([title rangeOfString:@"toolbar" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.toolbarIcon = YES;
        }
        else self.toolbarIcon = NO;
     */
    
    self.searchTitle = title;
    
    title = [title stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    self.title = title;
    
    GGIcon *anIcon = [[GGIcon alloc] init];
    anIcon.filePath = aBasePath;
    
    [self.variants addObject:anIcon];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:baseRetina]) {
        anIcon = [[GGIcon alloc] init];
        anIcon.filePath = baseRetina;
        
        [self.variants addObject:anIcon];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selectedPath]) {
        anIcon = [[GGIcon alloc] init];
        anIcon.filePath = selectedPath;
        
        [self.variants addObject:anIcon];
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:selectedRetinaPath]) {
        anIcon = [[GGIcon alloc] init];
        anIcon.filePath = selectedRetinaPath;
        
        [self.variants addObject:anIcon];
    }
}

- (NSString *)imageUID {
    return self.filePath;
}

- (NSArray *)tags {
    return GGMetadata.sharedInstance.combinedMetadata[self.iconName];
}

- (NSString *)imageTitle {
    NSString *title = [self.filePath.lastPathComponent stringByDeletingPathExtension];
    title = [title stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    title = [title stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    
    return title;
}

- (NSString *)imageRepresentationType {
    return IKImageBrowserPathRepresentationType;
}

- (id)imageRepresentation {
    if (self.svgIcon) {
        return self.pngPath;
    }
    else return self.filePath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (name=%@, path=%@)", self.title, self.iconName, self.imageRepresentation];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ (name=%@, path=%@)", self.title, self.iconName, self.imageRepresentation];    
}

@end
