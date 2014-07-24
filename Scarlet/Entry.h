//
//  Entry.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/22/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Box, Media, Tag;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Box *box;
@property (nonatomic, retain) NSSet *media;
@property (nonatomic, retain) NSSet *tags;

- (BOOL)isLeaf;
- (Box *)inbox;

@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addMediaObject:(Media *)value;
- (void)removeMediaObject:(Media *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
