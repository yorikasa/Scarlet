//
//  Box.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/27/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "Box.h"
#import "Entry.h"


@implementation Box

@dynamic name;
@dynamic entries;

- (BOOL)isLeaf{
    return NO;
}

@end
