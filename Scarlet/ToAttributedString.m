//
//  ToAttributedString.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/17/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "ToAttributedString.h"

@implementation ToAttributedString

+ (Class)transformedValueClass{
    return [NSAttributedString class];
}

+ (Class)reverseTransformedValueClass{
    return [NSString class];
}

- (id)transformedValue:(id)value{
    return value;
}

- (id)reverseTransformedValue:(id)value{
    return [value string];
}

@end
