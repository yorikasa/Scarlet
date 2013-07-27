//
//  ScarletAppDelegate.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/23/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ScarletAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak) IBOutlet NSTabView *contentTabView;
@property (weak) IBOutlet NSArrayController *entriesArrayController;
@property (weak) IBOutlet WebView *styledWebView;
@property (weak) IBOutlet NSSplitView *splitView;

- (IBAction)saveAction:(id)sender;
- (IBAction)changeContentTabView:(id)sender;

@end
