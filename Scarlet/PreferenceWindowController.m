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

NSString * const DefaultEditorFontName = @"Editor Font Name";
NSString * const DefaultEditorFontSize = @"Editor Font Size";
NSString * const DefaultEditorForegroundColor = @"Editor Foreground Color";
NSString * const DefaultEditorBackgroundColor = @"Editor Background Color";

NSString * const NotificationEditorFontChanged = @"EditorFontChanged";

@implementation PreferenceWindowController{
    NSUserDefaults *_defaults;
}

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
    // Load defaults
    _defaults = [NSUserDefaults standardUserDefaults];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [_toolbar setSelectedItemIdentifier:@"editor"];

    // Load font defaults
    NSString *fontName = [_defaults objectForKey:DefaultEditorFontName];
    NSNumber *fontSize = [_defaults objectForKey:DefaultEditorFontSize];
    NSFont *font = [NSFont fontWithName:fontName size:[fontSize intValue]];
    [_fontTextField setStringValue:[NSString stringWithFormat:@"%@, %ipt", [font displayName], (int)[font pointSize]]];

    // Load color defaults
    NSData *foregroundColorAsData = [_defaults objectForKey:DefaultEditorForegroundColor];
    NSColor *foregroundColor = [NSUnarchiver unarchiveObjectWithData:foregroundColorAsData];
    [_foregroundColorWell setColor:foregroundColor];
    NSData *backgroundColorAsData = [_defaults objectForKey:DefaultEditorBackgroundColor];
    NSColor *backgroundColor = [NSUnarchiver unarchiveObjectWithData:backgroundColorAsData];
    [_backgroundColorWell setColor:backgroundColor];
}

#pragma mark - Font settings

- (IBAction)showTab:(id)sender {
    [_tabView selectTabViewItemWithIdentifier:[[sender label] lowercaseString]];
}

- (IBAction)showFontPanel:(id)sender {
    [[NSFontManager sharedFontManager] setAction:@selector(changeEditorFont:)];
    [[NSFontManager sharedFontManager] orderFrontFontPanel:self];
}

- (void)changeEditorFont:(id)sender{
    NSString *oldName = [_defaults objectForKey:DefaultEditorFontName];
    NSNumber *oldSize = [_defaults objectForKey:DefaultEditorFontSize];
    NSFont *oldFont = [NSFont fontWithName:oldName size:[oldSize intValue]];

    NSFont *newFont = [sender convertFont:oldFont];
    NSString *newName = [newFont fontName];
    NSNumber *newSize = [NSNumber numberWithFloat:[newFont pointSize]];

    [_defaults setObject:newName forKey:DefaultEditorFontName];
    [_defaults setObject:newSize forKey:DefaultEditorFontSize];
    [_fontTextField setStringValue:[NSString stringWithFormat:@"%@, %ipt", [newFont displayName], (int)[newFont pointSize]]];
    [NSFont setUserFont:newFont];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationEditorFontChanged object:self];
}

#pragma mark - Color settings

- (IBAction)changeForegroundColor:(id)sender {
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject:[_foregroundColorWell color]];
    [_defaults setObject:colorAsData forKey:DefaultEditorForegroundColor];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationEditorFontChanged object:self];
}

- (IBAction)changeBackgroundColor:(id)sender {
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject:[_backgroundColorWell color]];
    [_defaults setObject:colorAsData forKey:DefaultEditorBackgroundColor];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationEditorFontChanged object:self];
}

- (IBAction)changeInsertionColor:(id)sender {
}








@end
