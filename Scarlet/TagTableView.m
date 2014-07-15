//
//  TagTableView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/15/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "TagTableView.h"

@implementation TagTableView

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
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    // Drawing code here.
}

@end
