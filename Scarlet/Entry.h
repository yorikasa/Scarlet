//
//  Entry.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/25/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSString * html;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *boxes;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addBoxesObject:(NSManagedObject *)value;
- (void)removeBoxesObject:(NSManagedObject *)value;
- (void)addBoxes:(NSSet *)values;
- (void)removeBoxes:(NSSet *)values;

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
