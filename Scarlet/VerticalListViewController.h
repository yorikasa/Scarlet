//
//  VerticalListViewController.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/2/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@class TagTableViewController;

@interface VerticalListViewController : NSViewController

#pragma mark - Variables
@property NSInteger isEditState;

#pragma mark - Methods
- (NSManagedObjectContext *)managedObjectContext;

#pragma mark - Controllers IBOutlet
@property (strong) IBOutlet NSArrayController *entryArrayController;
@property (strong) IBOutlet NSArrayController *boxArrayController;
@property (strong) IBOutlet NSArrayController *tagsArrayController;
@property (strong) IBOutlet TagTableViewController *tagTableViewController;


#pragma mark - UI Elements IBOutlet
@property (weak) IBOutlet NSTableView *entryTableView;
@property (weak) IBOutlet NSView *detailInfoView;
@property (weak) IBOutlet NSPopUpButton *boxPopUpButton;
@property (weak) IBOutlet NSTextField *boxNameTextField;
@property (unsafe_unretained) IBOutlet NSTextView *editorTextView;
@property (weak) IBOutlet WebView *htmlWebView;
@property (weak) IBOutlet NSButton *editButton;
@property (strong) IBOutlet NSPopover *createBoxPopOver;
@property (weak) IBOutlet NSButton *tagsButton;


#pragma mark - IBAction
- (IBAction)addBox:(id)sender;
- (IBAction)showAddBoxPopOver:(id)sender;
- (IBAction)showTagsPopOver:(id)sender;


@end
