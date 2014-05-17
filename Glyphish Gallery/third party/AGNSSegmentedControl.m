//
//  AGNSSegmentedControl.m
//  CustomNSSegment
//
//  Created by Seth Willits on 8/9/08.
//  Copyright 2008 Araelium Group. All rights reserved.
//

#import "AGNSSegmentedControl.h"



@interface NSSegmentedCell (AppleInternalPrivate)
- (void)setMenuIndicatorShown:(BOOL)shown forSegment:(NSInteger)segment;
@end



@implementation AGNSSegmentedControl

- (id)initWithFrame:(NSRect)frame;
{
	if (![super initWithFrame:frame]) return nil;
	
	mTargets = [[NSMutableDictionary alloc] init];
	mActions = [[NSMutableDictionary alloc] init];
	
	return self;
}


- (id)initWithCoder:(NSCoder *)coder;
{
	if (![super initWithCoder:coder]) return nil;
	
	mTargets = [[NSMutableDictionary alloc] init];
	mActions = [[NSMutableDictionary alloc] init];
	
	return self;
}

/* - (void)setSegmentCount:(NSInteger)count
    {
        AGForEachObject(id, targetKey, [[[mTargets allKeys] copy] objectEnumerator]) {
            if ([targetKey intValue] >= count) {
                [mTargets removeObjectForKey:targetKey];
            }
        }
        
        AGForEachObject(id, actionKey, [[[[mActions allKeys] copy] autorelease] objectEnumerator]) {
            if ([actionKey intValue] >= count) {
                [mActions removeObjectForKey:actionKey];
            }
        }
        
        [super setSegmentCount:count];
    }
*/


- (BOOL)selectSegmentWithTag:(NSInteger)tag;
{
	NSInteger segmentIndex = 0;
	for (segmentIndex = 0; segmentIndex < [self segmentCount]; segmentIndex++) {
		if ([self tagForSegment:segmentIndex] == tag) {
			[self setSelectedSegment:segmentIndex];
			return [self isSelectedForSegment:segmentIndex];
		}
	}
	
	if ([[self cell] trackingMode] == NSSegmentSwitchTrackingSelectOne) {
		for (segmentIndex = 0; segmentIndex < [self segmentCount]; segmentIndex++) {
			[self setSelected:NO forSegment:segmentIndex];
		}
	}
	
	return NO;
}


- (NSInteger)tagOfSelectedSegment;
{
	NSInteger segment = [self selectedSegment];
	if (segment == -1) return -1;
	return [self tagForSegment:segment];
}


// THIS IS A BUG FIX -- It really should be in NSSegmentedCell but that requires a lot of effort
- (NSInteger)selectedSegment;
{
	NSInteger segment = [[self cell] selectedSegment];
	NSInteger segmentIndex = 0;
	
	for (segmentIndex = 0; segmentIndex < [self segmentCount]; segmentIndex++) {
		if ([self isSelectedForSegment:segmentIndex] && segmentIndex == segment) {
			return segment;
		}
	}
	
	return -1;
}





#pragma mark -
#pragma mark Segment Target and Actions

- (void)setTag:(NSInteger)tag forSegment:(NSInteger)segment;
{
	[(NSSegmentedCell *)[self cell] setTag:tag forSegment:segment];
}


- (NSInteger)tagForSegment:(NSInteger)segment;
{
	return [(NSSegmentedCell *)[self cell] tagForSegment:segment];
}


- (void)setTarget:(id)target forSegment:(NSInteger)segment;
{
	if (target)
		[mTargets setObject:[NSValue valueWithPointer:(__bridge const void *)(target)] forKey:[NSNumber numberWithInt:(int)segment]];
	else
		[mTargets removeObjectForKey:[NSNumber numberWithInt:(int)segment]];
}


- (id)targetForSegment:(NSInteger)segment;
{
	id target = (id)[[mTargets objectForKey:[NSNumber numberWithInt:(int)segment]] pointerValue];
	if (!target) target = [self target];
	return target;
}


- (void)setAction:(SEL)action forSegment:(NSInteger)segment;
{
	[mActions setObject:NSStringFromSelector(action) forKey:[NSNumber numberWithInt:(int)segment]];
}


- (SEL)actionForSegment:(NSInteger)segment;
{
	SEL selector = NSSelectorFromString([mActions objectForKey:[NSNumber numberWithInt:(int)segment]]);
	if (!selector) selector = [self action];
	return selector;
}


- (BOOL)sendAction:(SEL)theAction to:(id)theTarget
{
	NSInteger segment = [self selectedSegment];
	if (segment != -1) {
		SEL segmentAction = [self actionForSegment:segment];
		id  segmentTarget = [self targetForSegment:segment];
		
		if (segmentAction) theAction = segmentAction;
		if (segmentTarget) theTarget = segmentTarget;
	}
	
	return [super sendAction:theAction to:theTarget];
}


- (void)setMenuIndicatorShown:(BOOL)shown forSegment:(NSInteger)segment;
{
	if ([[self cell] respondsToSelector:@selector(setMenuIndicatorShown:forSegment:)]) {
		[[self cell] setMenuIndicatorShown:shown forSegment:segment];
	}
}

@end
