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

#pragma mark - Methods
- (NSURL *)applicationFilesDirectory;

#pragma mark - View Controllers
@property NSMutableArray *viewControllers;
@property VerticalListViewController *verticalListViewController;

#pragma mark - Menu Items
@property (weak) IBOutlet NSMenuItem *menuSortByDateCreated;
@property (weak) IBOutlet NSMenuItem *menuSortByDateModified;
@property (weak) IBOutlet NSMenuItem *menuSortByTitle;
@property (weak) IBOutlet NSMenuItem *menuSortAscending;
@property (weak) IBOutlet NSMenuItem *menuSortDescending;

#pragma mark - UI Elements Outlets
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *blankView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSSearchField *searchField;

#pragma mark - Actions
- (IBAction)addOrRemoveEntry:(id)sender;
- (IBAction)search:(id)sender;

#pragma mark - Menu Bar Actions
- (IBAction)menuBarNew:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)changeSort:(id)sender;
- (IBAction)changeOrder:(id)sender;
- (IBAction)showPreferenceWindow:(id)sender;

@end

