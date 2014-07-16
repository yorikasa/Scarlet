//
//  PreferenceWindowController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/16/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "PreferenceWindowController.h"

@interface PreferenceWindowController ()

@end

@implementation PreferenceWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init{
    if (![super initWithWindowNibName:@"Preference"]) {
        return nil;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)showTab:(id)sender {
    [_tabView selectTabViewItemWithIdentifier:[[sender label] lowercaseString]];
}

- (IBAction)showFontPanel:(id)sender {
}
@end
