//
//  HTMLWebView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/18/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "HTMLWebView.h"

@implementation HTMLWebView

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

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationNone;
}
- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    return NSDragOperationNone;
}

@end
