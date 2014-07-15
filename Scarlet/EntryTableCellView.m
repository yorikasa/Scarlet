//
//  EntryTableCellView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/10/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "EntryTableCellView.h"

@implementation EntryTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.

    }
    return self;
}

//- (void)awakeFromNib{
//    [super awakeFromNib];
//    NSTrackingArea *trackArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, 100, 100)
//                            options:(NSTrackingInVisibleRect | NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited)
//                                                               owner:self userInfo:nil];
//    [self addTrackingArea:trackArea];
//}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
