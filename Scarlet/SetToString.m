//
//  SetToString.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/13/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "SetToString.h"

@implementation SetToString

+ (Class)transformedValueClass{
    return [NSString class];
}

- (id)transformedValue:(id)value{
    if (!value || [value count] == 0) {
        return nil;
    }
    NSMutableString *result = [[NSMutableString alloc] init];

    for (id tag in value) {
        [result appendFormat:@"%@, ",[tag name]];
    }

    [result deleteCharactersInRange:NSMakeRange([result length]-2, 2)];
    return (NSString *)result;
}

@end
