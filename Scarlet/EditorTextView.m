//
//  EditorTextView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/18/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "EditorTextView.h"

@implementation EditorTextView{
    BOOL isUnregistered;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    isUnregistered = NO;

}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

}

- (void)updateDragTypeRegistration{
    [self unregisterDraggedTypes];
    [self registerForDraggedTypes:@[NSPasteboardTypeString]];
}

- (NSArray *)acceptableDragTypes{
    return nil;
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
