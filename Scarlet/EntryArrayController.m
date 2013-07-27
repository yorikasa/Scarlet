//
//  EntryArrayController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/24/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "EntryArrayController.h"
#import "libMultiMarkdown.h"

@implementation EntryArrayController

- (id) newObject{
    id newObj = [super newObject];
    NSDate *now = [NSDate date];
    [newObj setValue:now forKey:@"dateCreated"];
//    NSString *source = @"#This is Header\n - and\n- this\n- is\n list!\n```\nsome code\n```\n";
//    NSLog(@"%s",markdown_to_string((char *)[source UTF8String],1,0));
    return newObj;
}

@end
