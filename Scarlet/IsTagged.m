//
//  IsTagged.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/14/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "IsTagged.h"
#import "ScarletAppDelegate.h"
#import "VerticalListViewController.h"
#import "Entry.h"
#import "Tag.h"

@implementation IsTagged

+ (Class)transformedValueClass{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation{
    return NO;
}

// ObjectValue.name -> BOOL
- (id)transformedValue:(id)value{
    // value == (NSString *)[tag name]
    NSArrayController *entries = [[(ScarletAppDelegate *)[NSApp delegate] verticalListViewController] entryArrayController];
    if ([[entries selectedObjects] count] == 1) {
        for (Tag *tag in [(Entry *)[entries selectedObjects][0] tags]) {
            if ([[tag name] isEqualToString:(NSString *)value]){
                return @YES;
            }
        }
    }
    return @NO;
}


@end
