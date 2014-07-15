//
//  HTMLTransformer.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/1/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "HTMLTransformer.h"
#import "libMultiMarkdown.h"

@implementation HTMLTransformer

+ (Class)transformedValueClass{
    return [NSString class];
}

- (id)transformedValue:(id)value{
    if (!value) {
        return nil;
    }
    return @(markdown_to_string((char *)[value UTF8String], EXT_NOTES + EXT_NO_METADATA,0));
}
@end
