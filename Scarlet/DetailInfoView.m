//
//  DetailInfoView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/13/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "DetailInfoView.h"

#define NSColorFromRGB(rgbValue) [NSColor colorWithSRGBRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - Category

@implementation NSBezierPath (BezierPathQuartzUtilities)
// This method works only in OS X v10.2 and later.
- (CGPathRef)quartzPath
{
    int i, numElements;

    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;

    // Then draw the path elements.
    numElements = (int)[self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;

        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;

                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;

                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;

                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }

        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);

        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    
    return immutablePath;
}
@end

@implementation DetailInfoView

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
    [NSColorFromRGB(0xffffff) setFill];
    NSRectFill(dirtyRect);
//
////    NSShadow *dropShadow = [[NSShadow alloc] init];
////    [dropShadow setShadowColor:[NSColor lightGrayColor]];
////    [dropShadow setShadowOffset:NSMakeSize(0, 2)];
////    [dropShadow setShadowBlurRadius:5.0];
//
//    [self.layer setShadowColor:[NSColor lightGrayColor].CGColor];
//    [self.layer setShadowOpacity:1.0f];
//    [self.layer setShadowRadius:5.0f];
//    [self.layer setShadowPath:[[NSBezierPath bezierPathWithRect:dirtyRect] quartzPath]];
//
//    //[self setWantsLayer: YES];
//    //[self setShadow: dropShadow];
//    self.layer.shouldRasterize = YES;
}

@end
