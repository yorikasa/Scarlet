//
//  Media.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/22/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Media (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
