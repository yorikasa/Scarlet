//
//  ContentController.h
//  Scarlet
//
//  Created by Yuki Orikasa on 8/26/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
//@class EntryArrayController;
@class Entry;

@interface ContentController : NSObject

@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet WebView *styledWebView;
//@property (weak) IBOutlet EntryArrayController *entriesArrayController;
@property (weak) IBOutlet NSView *styledView;
@property (weak) IBOutlet NSView *editorView;
@property (weak) IBOutlet NSButton *editButton;

- (IBAction)switchTabView:(id)sender;

- (void)loadStyledView:(Entry *)entry;

@end
