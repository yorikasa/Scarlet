//
//  PreferenceWindowController.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/16/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceWindowController : NSWindowController

#pragma mark - (Global) Variables
extern NSString * const DefaultEditorFontName;
extern NSString * const DefaultEditorFontSize;
extern NSString * const DefaultEditorForegroundColor;
extern NSString * const DefaultEditorBackgroundColor;

extern NSString * const NotificationEditorFontChanged;


#pragma mark - Actions
- (IBAction)showTab:(id)sender;
- (IBAction)showFontPanel:(id)sender;
- (IBAction)changeForegroundColor:(id)sender;
- (IBAction)changeBackgroundColor:(id)sender;


#pragma mark - IBOutlets
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSColorWell *foregroundColorWell;
@property (weak) IBOutlet NSColorWell *backgroundColorWell;
@property (weak) IBOutlet NSTextField *fontTextField;
@property (weak) IBOutlet NSToolbar *toolbar;


@end
