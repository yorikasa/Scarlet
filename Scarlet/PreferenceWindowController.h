//
//  PreferenceWindowController.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/16/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceWindowController : NSWindowController


#pragma mark - Actions
- (IBAction)showTab:(id)sender;
- (IBAction)showFontPanel:(id)sender;


#pragma mark - IBOutlets
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSColorWell *foregroundColorWell;
@property (weak) IBOutlet NSColorWell *backgroundColorWell;
@property (weak) IBOutlet NSTextField *fontTextField;


@end
