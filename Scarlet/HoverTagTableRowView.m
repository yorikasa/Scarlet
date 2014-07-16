//
//  HoverTagTableRowView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/15/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "HoverTagTableRowView.h"
#define NSColorFromRGB(rgbValue) [NSColor colorWithSRGBRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation HoverTagTableRowView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, 100, 100) options:(NSTrackingInVisibleRect | NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited) owner:self userInfo:nil];
    }

    if (![[self trackingAreas] containsObject:_trackingArea]) {
        [self addTrackingArea:_trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseInside = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent{
    _mouseInside = NO;
    [self setNeedsDisplay:YES];
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect{
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);

    if (_mouseInside) {
        [NSColorFromRGB(0xf5f5f5) set];
        NSRectFill(self.bounds);
    }
}

@end
