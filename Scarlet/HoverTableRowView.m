//
//  HoverTableRowView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/11/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "HoverTableRowView.h"
#define NSColorFromRGB(rgbValue) [NSColor colorWithSRGBRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation HoverTableRowView

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

- (void)mouseEntered:(NSEvent *)theEvent {
    //
}

// Only called if the 'selected' property is yes.
- (void)drawSelectionInRect:(NSRect)dirtyRect {
    // Check the selectionHighlightStyle, in case it was set to None
    if ([self isEmphasized]) {
        if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
            NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                                    NSColorFromRGB(0xececec), 0.0,
                                    NSColorFromRGB(0xf5f5f5), 0.15,
                                    NSColorFromRGB(0xf5f5f5), 0.85,
                                    NSColorFromRGB(0xececec), 1.0, nil];
            [gradient drawInRect:[self bounds] angle:270];
        }
    }else{
        [NSColorFromRGB(0xf5f5f5) setFill];
        NSRectFill([self bounds]);
    }
    // [super drawSelectionInRect:dirtyRect];
}

- (NSBackgroundStyle)interiorBackgroundStyle {
    return NSBackgroundStyleLight;
}

@end
