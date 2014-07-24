//
//  FirstItem.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/22/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "AnyItem.h"
#import "Media.h"

@implementation AnyItem


+ (Class)transformedValueClass{
    return [NSString class];
}

- (id)transformedValue:(id)value{
    // value == nsset
    return [(Media *)[(NSSet *)value anyObject] location];
}

@end
