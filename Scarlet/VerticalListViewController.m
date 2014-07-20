//
//  VerticalListViewController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/2/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "VerticalListViewController.h"
#import "ScarletAppDelegate.h"
#import "Entry.h"
#import "Box.h"
#import "Tag.h"
#import "libMultiMarkdown.h"
#import "TagCellView.h"
#import "TagTableViewController.h"
#import "PreferenceWindowController.h"

@interface VerticalListViewController ()

@end

@implementation VerticalListViewController{
    NSUserDefaults *_defaults;
}

int gIsEditing = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"VerticalListView" bundle:nil];
    if (self){
        // Further initialization if needed
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_editorTextView setTextContainerInset:NSMakeSize(5, 10)];
        [_editButton setState:0];
        _isEditState = 0;

        _defaults = [NSUserDefaults standardUserDefaults];
        [NSFont setUserFont:[NSFont fontWithName:[_defaults objectForKey:DefaultEditorFontName] size:[[_defaults objectForKey:DefaultEditorFontSize] intValue]]];
        [_editorTextView setFont:[NSFont userFontOfSize:0.0]];

        NSColor *textColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorForegroundColor]];
        NSColor *backColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorBackgroundColor]];
        [_editorTextView setTextColor:textColor];
        [_editorTextView setBackgroundColor:backColor];

        // and Notification...
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(reloadTextView:) name:NotificationEditorFontChanged object:nil];
        [nc addObserver:self selector:@selector(keepFont:) name:NSTextDidChangeNotification object:_editorTextView];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext{
    return [(ScarletAppDelegate *)[NSApp delegate] managedObjectContext];
}

#pragma mark - Table View Delegates / Data Source

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    [_entryTableView scrollRowToVisible:[_entryTableView selectedRow]];

    // For new notes, open edit view. Otherwise, open HTML view
    [self willChangeValueForKey:@"isEditState"];
    _isEditState = 0;
    if ([[_entryArrayController selectedObjects] count] == 1) {
        if ([[(Entry *)[_entryArrayController selectedObjects][0] dateCreated] timeIntervalSinceNow] > -1){
            _isEditState = 1;
        }
    }
    [self didChangeValueForKey:@"isEditState"];
    [self loadHTMLWithStyle];
    [_editorTextView setFont:[NSFont userFontOfSize:0.0]];

    NSColor *textColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorForegroundColor]];
    NSColor *backColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorBackgroundColor]];
    [_editorTextView setTextColor:textColor];
    [_editorTextView setBackgroundColor:backColor];
}

#pragma mark - Tags Button

- (IBAction)showTagsPopOver:(id)sender {
    [[_tagTableViewController searchField] setStringValue:@""];
    [_tagTableViewController controlTextDidChange:nil];
    [[_tagTableViewController tagsPopOver] showRelativeToRect:[_tagsButton bounds] ofView:_tagsButton preferredEdge:NSMaxYEdge];
}

#pragma mark - Edit Button

- (IBAction)clickEdit:(id)sender {
    switch ((NSInteger)[sender state]) {
        case 0:{ // Editor to Viewer
            if (![[_entryArrayController selectedObjects][0] title]) {
                Entry *selected = [_entryArrayController selectedObjects][0];
                NSString *content = [[NSKeyedUnarchiver unarchiveObjectWithData:[selected content]] string];
                NSString *newTitle = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]][0];
                if ([newTitle length] > 50) {
                    newTitle = [NSString stringWithFormat:@"%@...", [newTitle substringToIndex:50]];
                }
                [[_entryArrayController selectedObjects][0] setTitle:newTitle];
            }
            [self loadHTMLWithStyle];;
            break;
        }case 1:{ // Viewer to Editor
            ;
            break;
        }
    }
}

#pragma mark - Box Popup and Popover

- (IBAction)showAddBoxPopOver:(id)sender {
    [_createBoxPopOver showRelativeToRect:[_boxPopUpButton bounds] ofView:_boxPopUpButton preferredEdge:NSMaxYEdge];
}

- (IBAction)addBox:(id)sender{
    if (![[sender stringValue] isEqualToString:@""]){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Box" inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name LIKE %@", [_boxNameTextField stringValue]];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
        if (array != nil) {
            if ([array count] == 0) {
                Box *newBox = [_boxArrayController newObject];
                [newBox setName:[_boxNameTextField stringValue]];
                [_boxArrayController addObject:newBox];
                [_boxPopUpButton selectItemWithTitle:[_boxNameTextField stringValue]];
                for (Entry *entry in _entryArrayController.selectedObjects) {
                    entry.box = newBox;
                }
            }
        }
        else{
            // error handling
        }
        [_createBoxPopOver close];
        [_boxNameTextField setStringValue:@""];
    }
}

- (void)appendCustomBoxMenuItems{
    [[_boxPopUpButton menu] addItem:[NSMenuItem separatorItem]];
    [[_boxPopUpButton menu] addItem:[[NSMenuItem alloc] initWithTitle:@"Add New Box..." action:NULL keyEquivalent:@""]];
}

#pragma mark - Editor

- (void)reloadTextView:(NSNotification *)note{
    [_editorTextView setFont:[NSFont fontWithName:[_defaults objectForKey:DefaultEditorFontName] size:[[_defaults objectForKey:DefaultEditorFontSize] intValue]]];

    NSColor *textColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorForegroundColor]];
    NSColor *backColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorBackgroundColor]];
    [_editorTextView setTextColor:textColor];
    [_editorTextView setBackgroundColor:backColor];
}

- (void)keepFont:(NSNotification *)note{
    [_editorTextView setFont:[NSFont userFontOfSize:0.0]];
}

#pragma mark -

- (void)loadHTMLWithStyle{
    NSString *html;
    NSArray *selected = [_entryArrayController selectedObjects];
    if ([selected count] == 1) {
        NSData *contentData = [(Entry *)selected[0] content];
        if (contentData) {
            NSString *content = [[NSKeyedUnarchiver unarchiveObjectWithData:contentData] string];
            html = @(markdown_to_string((char *)[content UTF8String], EXT_NOTES + EXT_NO_METADATA,0));
        }
    }
    NSString *style = @"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />";
    NSString *newHTML = [NSString stringWithFormat:@"%@%@", style, html];
    [[_htmlWebView mainFrame] loadHTMLString:newHTML baseURL:[(ScarletAppDelegate *)[NSApp delegate] applicationFilesDirectory]];
}


@end