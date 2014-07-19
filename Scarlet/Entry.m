//
//  Entry.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/27/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "Entry.h"
#import "Box.h"
#import "ScarletAppDelegate.h"


@implementation Entry

@dynamic content;
@dynamic dateCreated;
@dynamic dateModified;
@dynamic title;
@dynamic box;
@dynamic tags;

- (void)awakeFromInsert{
    [super awakeFromInsert];
    [self setDateCreated:[NSDate date]];
    [self setDateModified:[NSDate date]];
    [self setTitle:nil];
    
    // Find "Inbox" box and set it to self.box
    [self setBox:[self inbox]];
}

- (Box *)inbox{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Box" inManagedObjectContext:context];
    [request setEntity:entity];
    NSString *defaultBoxName = @"Inbox";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name LIKE %@", defaultBoxName];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (!array){
        //error
    }
    if ([array count] == 0) {
        NSEntityDescription *boxEntity = [NSEntityDescription entityForName:@"Box"
                                                     inManagedObjectContext:[self managedObjectContext]];
        Box *newBox = [[Box alloc] initWithEntity:boxEntity insertIntoManagedObjectContext:[self managedObjectContext]];
        [newBox setName:@"Inbox"];
        return newBox;
    }
    return [array objectAtIndex:0];
}

- (BOOL)isLeaf{
    return YES;
}

#pragma mark -

- (void)willSave{
    
}




@end
