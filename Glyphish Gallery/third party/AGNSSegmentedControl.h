//
//  AGNSSegmentedControl.h
//  CustomNSSegment
//
//  Created by Seth Willits on 8/9/08.
//  Copyright 2008 Araelium Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AGNSSegmentedControl : NSSegmentedControl {
	NSMutableDictionary * mTargets;
	NSMutableDictionary * mActions;
}

// Segment Attributes
- (NSInteger)tagOfSelectedSegment;
- (void)setTag:(NSInteger)tag forSegment:(NSInteger)segment;
- (NSInteger)tagForSegment:(NSInteger)segment;
- (void)setTarget:(id)target forSegment:(NSInteger)segment;
- (id)targetForSegment:(NSInteger)segment;
- (void)setAction:(SEL)action forSegment:(NSInteger)segment;
- (SEL)actionForSegment:(NSInteger)segment;

// Menus
- (void)setMenuIndicatorShown:(BOOL)shown forSegment:(NSInteger)segment;

@end
