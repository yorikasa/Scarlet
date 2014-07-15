//
//  HoverTagTableRowView.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/15/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HoverTagTableRowView : NSTableRowView

@property NSTrackingArea *trackingArea;
@property BOOL mouseInside;

@end
