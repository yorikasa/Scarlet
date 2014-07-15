//
//  StyledHeaderView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 8/28/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "StyledHeaderView.h"

@implementation StyledHeaderView

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
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:[self bounds]];
}

@end
