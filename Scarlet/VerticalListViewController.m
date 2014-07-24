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
#import "Media.h"
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
        NSColor *insertColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorInsertionColor]];
        [_editorTextView setTextColor:textColor];
        [_editorTextView setBackgroundColor:backColor];
        [_editorTextView setInsertionPointColor:insertColor];

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
        }else{
            [self loadHTMLWithStyle];
        }
    }
    [self didChangeValueForKey:@"isEditState"];
    [_editorTextView setFont:[NSFont userFontOfSize:0.0]];
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
            // Set auto title
            if (![[_entryArrayController selectedObjects][0] title]) {
                Entry *selected = [_entryArrayController selectedObjects][0];
                NSString *content = [selected content];
                NSString *newTitle = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]][0];
                if ([newTitle length] > 50) {
                    newTitle = [NSString stringWithFormat:@"%@...", [newTitle substringToIndex:50]];
                }
                [[_entryArrayController selectedObjects][0] setTitle:newTitle];
            }
            // Media entity confirmation
            NSSet *images = [(Entry *)[_entryArrayController selectedObjects][0] media];
            NSMutableArray *imagesToDelete = [[NSMutableArray alloc] init];
            Entry *entry = [_entryArrayController selectedObjects][0];
            NSString *content = [entry content];
            for (Media *image in images) {
                NSURL *url = [NSURL fileURLWithPath:[image location]];
                NSString *patternString = [NSString stringWithFormat:@"!\\[.*?\\]\\(%@\\)", [url absoluteString]];
                NSError *error;
                NSRegularExpression *imageLink = [NSRegularExpression regularExpressionWithPattern:patternString options:NSRegularExpressionCaseInsensitive error:&error];
                if (error) {
                    NSLog(@"SHIIIIIIIIIIIIIIIIIT: %@", error);
                }
                if (content) {
                    if (![imageLink numberOfMatchesInString:content options:0 range:NSMakeRange(0, [content length])]) {
                        // Shit! I cannot modify images set (look at forin loop expression!)
                        NSLog(@"delete you!");
                        [imagesToDelete addObject:image];
                    }
                }else{
                    NSLog(@"delete you, anyway!");
                    [imagesToDelete addObject:image];
                }
            }
            int loopNum = (int)[imagesToDelete count];
            NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
            for (int i = 0; i < loopNum; i++) {
                [entry removeMediaObject:imagesToDelete[i]];
                [self removeItemAtURL:[NSURL fileURLWithPath:[(Media *)imagesToDelete[i] location]]];
                [moc deleteObject:imagesToDelete[i]];
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
    NSColor *insertColor = [NSUnarchiver unarchiveObjectWithData:[_defaults objectForKey:DefaultEditorInsertionColor]];
    [_editorTextView setTextColor:textColor];
    [_editorTextView setBackgroundColor:backColor];
    [_editorTextView setInsertionPointColor:insertColor];
}

- (void)keepFont:(NSNotification *)note{
    [_editorTextView setFont:[NSFont userFontOfSize:0.0]];
}

#pragma mark -

- (void)loadHTMLWithStyle{
    NSString *html;
    NSArray *selected = [_entryArrayController selectedObjects];
    if ([selected count] == 1) {
        NSString *content = [(Entry *)selected[0] content];
        if (content) {
            html = @(markdown_to_string((char *)[content UTF8String], EXT_NOTES + EXT_NO_METADATA,0));
        }
    }
    NSString *style = @"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />";
    NSString *newHTML = [NSString stringWithFormat:@"%@%@", style, html];
    [[_htmlWebView mainFrame] loadHTMLString:newHTML baseURL:[(ScarletAppDelegate *)[NSApp delegate] applicationFilesDirectory]];
}

- (BOOL)removeItemAtURL:(NSURL *)url{
    NSError *error = nil;
    NSURL *renamedURL;
    [[NSFileManager defaultManager] trashItemAtURL:url resultingItemURL:&renamedURL error:&error];
    if (error) {
        NSLog(@"cannot write!, %@", error);
        return NO;
    }
    else{
        NSURL *parentDirectory = [url URLByDeletingLastPathComponent];
        if ([[[NSFileManager defaultManager] contentsOfDirectoryAtURL:parentDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error] count] == 0) {
            [[NSFileManager defaultManager] removeItemAtURL:parentDirectory error:&error];
            return YES;
        }else{
            return NO;
        }
    }
}


@end