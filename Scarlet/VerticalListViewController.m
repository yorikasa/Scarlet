//
//  VerticalListViewController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/2/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "VerticalListViewController.h"
#import "ScarletAppDelegate.h"
#import "EntryTableCellView.h"
#import "Entry.h"
#import "Box.h"
#import "Tag.h"
#import "libMultiMarkdown.h"
#import "TagCellView.h"
#import "TagTableViewController.h"

@interface VerticalListViewController ()

@end

@implementation VerticalListViewController

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

    // About Tags Token Field
    [_tagsTokenField setEnabled:YES];
    [[_tagsTokenField cell] setPlaceholderString:@"Add Tags..."];
    if ([[_entryArrayController selectedObjects] count] == 1) {
        [_tagsTokenField setObjectValue:[[[_entryArrayController selectedObjects][0] tags] allObjects]];
    }else if ([[_entryArrayController selectedObjects] count] == 0){
        [_tagsTokenField setObjectValue:@[]];
        [_tagsTokenField setEnabled:NO];
        [[_tagsTokenField cell] setPlaceholderString:@"No Selection"];
    }else{
        [_tagsTokenField setObjectValue:@[]];
        [[_tagsTokenField cell] setPlaceholderString:@"Multiple Selection"];
    }
}

#pragma mark - NSTokenField Delegates

- (NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject{
    return [representedObject name];
}

- (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString{

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name LIKE %@", editingString];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    //Tag *newTag = nil;
    if (array != nil) {
        if ([array count] == 0) {
            NSEntityDescription *tagEntity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:[self managedObjectContext]];
            Tag *newTag = [[Tag alloc] initWithEntity:tagEntity insertIntoManagedObjectContext:[self  managedObjectContext]];
            [newTag setName:editingString];
            return newTag;
        }else if ([array count] == 1){
            return array[0];
        }
    }
    else{
        // error handling
    }
    return nil;
}

- (BOOL)tokenField:(NSTokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject {
    return YES;
}

- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(id)representedObject {
    NSMenu *tokenMenu = [[NSMenu alloc] init];

    if (!representedObject){
        return nil;
    }
    NSMenuItem *showItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Show Notes tagged with \"%@\"", [representedObject name]] action:@selector(showRelatedNotes:) keyEquivalent:@""];
    [showItem setTarget:self];
    [showItem setRepresentedObject:representedObject];
    [tokenMenu addItem:showItem];

    return tokenMenu;
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification{
    gIsEditing = 1;
}

- (void)controlTextDidChange:(NSNotification *)aNotification{
    gIsEditing = 1;
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification{
    if (gIsEditing == 1) {
        for (Entry *entry in [_entryArrayController selectedObjects]) {
            [entry setTags:[NSSet setWithArray:[_tagsTokenField objectValue]]];
        }
    }
    gIsEditing = 0;
}

#pragma mark - Tags Token Field & Button

- (IBAction)returnTagsTokenField:(id)sender {
    for (Entry *entry in [_entryArrayController selectedObjects]) {
        [entry setTags:[NSSet setWithArray:[_tagsTokenField objectValue]]];
    }
}

- (IBAction)showTagsPopOver:(id)sender {
    [[_tagTableViewController searchField] setStringValue:@""];
    [[_tagTableViewController tagTableView] reloadData];
    [[_tagTableViewController tagsPopOver] showRelativeToRect:[_tagsButton bounds] ofView:_tagsButton preferredEdge:NSMaxYEdge];
}

- (void)showRelatedNotes:(id)sender{
}


#pragma - Table View Sorting

//- (void)setSortDescriptorsWithKey:(NSString *)key ascending:(BOOL)order option:(BOOL)option{
//    if (option) {
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:order selector:@selector(caseInsensitiveCompare:)]]];
//    }
//    else{
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:order]]];
//    }
//}
//
//- (void)prepareSort{
//    BOOL option;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] isEqualToString:@"title"]) {
//        option = YES;
//        [_menuSortByTitle setState:NSOnState];
//    }
//    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] isEqualToString:@"dateCreated"]){
//        [_menuSortByDateCreated setState:NSOnState];
//        option = NO;
//    }
//    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] isEqualToString:@"dateModified"]){
//        [_menuSortByDateModified setState:NSOnState];
//        option = NO;
//    }
//    else{
//        option = NO;
//    }
//
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sortAscending"]) {
//        [_menuSortAscending setState:NSOnState];
//    }
//    else{
//        [_menuSortDescending setState:NSOnState];
//    }
//
//    [self setSortDescriptorsWithKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] ascending:[[NSUserDefaults standardUserDefaults] boolForKey:@"sortAscending"] option:option];
//}

#pragma mark - Box Popup and Popover

- (IBAction)showAddBoxPopOver:(id)sender {
    [_createBoxPopOver showRelativeToRect:[_boxPopUpButton bounds] ofView:_boxPopUpButton preferredEdge:NSMaxYEdge];
}

- (IBAction)addBox:(id)sender{
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

- (void)appendCustomBoxMenuItems{
    [[_boxPopUpButton menu] addItem:[NSMenuItem separatorItem]];
    [[_boxPopUpButton menu] addItem:[[NSMenuItem alloc] initWithTitle:@"Add New Box..." action:NULL keyEquivalent:@""]];
}

#pragma mark -

- (void)loadHTMLWithStyle{
    NSString *html;
    NSArray *selected = [_entryArrayController selectedObjects];
    if ([selected count] == 1) {
        if ([(Entry *)selected[0] content]) {
            html = @(markdown_to_string((char *)[[(Entry *)selected[0] content] UTF8String], EXT_NOTES + EXT_NO_METADATA,0));
        }
    }
    NSString *style = @"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />";
    NSString *newHTML = [NSString stringWithFormat:@"%@%@", style, html];
    [[_htmlWebView mainFrame] loadHTMLString:newHTML baseURL:[(ScarletAppDelegate *)[NSApp delegate] applicationFilesDirectory]];
}


@end