//
//  Entry.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/27/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Box;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Box *box;
@property (nonatomic, retain) NSSet *tags;

- (BOOL)isLeaf;
- (Box *)inbox;

@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
