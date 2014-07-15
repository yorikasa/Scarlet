//
//  IsEmpty.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/11/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "IsEmpty.h"

@implementation IsEmpty

+ (Class)transformedValueClass{
    return [NSNumber class];
}

- (id)transformedValue:(id)value{
    if ([value count] == 0) {
        return @YES;
    }
    return @NO;
}

@end
