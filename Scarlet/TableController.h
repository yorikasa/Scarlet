//
//  TableController.h
//  Scarlet
//
//  Created by Yuki Orikasa on 8/8/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ContentController;
@class EntryTableCellView;

@interface TableController : NSObject

//@property (weak) IBOutlet NSMenuItem *menuSortByDateCreated;
//@property (weak) IBOutlet NSMenuItem *menuSortByDateModified;
//@property (weak) IBOutlet NSMenuItem *menuSortByTitle;
//@property (weak) IBOutlet NSMenuItem *menuSortAscending;
//@property (weak) IBOutlet NSMenuItem *menuSortDescending;
//@property (weak) IBOutlet NSButton *editButton;

//@property (weak) IBOutlet NSArrayController *entriesArrayController;
//@property (weak) IBOutlet ContentController *contentController;
//@property (weak) IBOutlet NSTextField *dateText;
@property (weak) IBOutlet NSTableView *entriesTableView;

- (IBAction)changeSort:(id)sender;
- (IBAction)changeOrder:(id)sender;

-(void)prepareSort;

@end
