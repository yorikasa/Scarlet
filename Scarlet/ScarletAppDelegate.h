//
//  ScarletAppDelegate.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/23/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@class VerticalListViewController;

@interface ScarletAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property NSMutableArray *viewControllers;
@property (weak) NSViewController *currentViewController;
@property VerticalListViewController *verticalListViewController;

@property (weak) IBOutlet NSArrayController *entriesArrayController;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *blankView;
@property (weak) IBOutlet NSView *contentView;

- (NSURL *)applicationFilesDirectory;

//@property (weak) NSView *verticalListView;
- (IBAction)addOrRemoveEntry:(id)sender;

- (IBAction)saveAction:(id)sender;
- (IBAction)menuBarNew:(id)sender;

- (IBAction)updatePredicate:(id)sender;
@property (weak) IBOutlet NSSearchField *searchField;

@end
