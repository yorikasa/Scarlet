//
//  TagTableViewController.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/14/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class VerticalListViewController;

@interface TagTableViewController : NSViewController

@property (unsafe_unretained) IBOutlet VerticalListViewController *verticalListViewController;
@property (weak) IBOutlet NSArrayController *tagArrayController;
@property (weak) IBOutlet NSArrayController *entryArrayController;

- (IBAction)toggleTagState:(id)sender;
@property (weak) IBOutlet NSTableView *tagTableView;
@property (strong) IBOutlet NSPopover *tagsPopOver;
@property (weak) IBOutlet NSTextField *searchField;

@end
