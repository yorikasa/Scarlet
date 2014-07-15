//
//  ContentController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 8/26/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "ContentController.h"
//#import "EntryArrayController.h"
#import "libMultiMarkdown.h"
#import "Entry.h"
#import "ScarletAppDelegate.h"

@implementation ContentController

- (id)init{
    if (self = [super init]) {
        ;
    }
    return self;
}

// Copied from App Delegate...
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.yorikasa.Scarlet"];
}

#pragma mark -

- (void)loadHTMLWithStyle:(NSString *)html{
    NSString *style = @"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />";
    NSString *newHTML = [NSString stringWithFormat:@"%@%@", style, html];
    [[_styledWebView mainFrame] loadHTMLString:newHTML baseURL:[self applicationFilesDirectory]];
}

// Called from TableController (Table View Delegate: tableViewSelectedDidChange)
- (void)loadStyledView:(Entry *)entry{
//    if (entry) {
//        if ([entry content]) {
//            [self loadHTMLWithStyle:[entry html]];
//        }else{
//            [self loadHTMLWithStyle:@""];
//        }
//        if ([[[_tabView selectedTabViewItem] identifier] isEqualToString:@"editor"]) {
//            if ([[entry dateCreated] timeIntervalSinceNow] < -1){
//                [_tabView selectTabViewItemWithIdentifier:@"styled"];
//                //[_editButton setState:1];
//            }else{
//                [_editButton setState:1];
//            }
//        }
//    }else{
//        [self loadHTMLWithStyle:@""];
//    }
}

#pragma mark - Actions

- (IBAction)switchTabView:(id)sender {
//    NSLog(@"%ld", [sender state]);
//    if ([sender state] == 1){
//        [_tabView selectTabViewItemWithIdentifier:@"editor"];
//    }
//    else{
//        [_tabView selectTabViewItemWithIdentifier:@"styled"];
//
//        // Convert HTML to Markdown
//        NSArray *selected = [_entriesArrayController selectedObjects];
//        if (selected && [selected count] == 1) {
//            Entry *selectedEntry = [selected objectAtIndex:0];
//            if ([selectedEntry content]) {
//                NSString *html = @(markdown_to_string((char *)[[selectedEntry content] UTF8String],EXT_NOTES + EXT_NO_METADATA,0));
//                [selectedEntry setValue:html forKey:@"html"];
//                [self loadHTMLWithStyle:html];
//            }
//            // Wrong: it modifies whenever the tab switches, either the content is edited or not.
//            // [selectedEntry setDateModified:[NSDate date]];
//            ScarletAppDelegate *appDelegate = (ScarletAppDelegate *)[NSApp delegate];
//            NSError *error = nil;
//            [[appDelegate managedObjectContext] save:&error];
//        }
//    }

//    if ([[sender identifier] isEqualToString:@"styledViewButton"]) {
//        [_tabView selectTabViewItemWithIdentifier:@"editor"];
//    }
//    else if ([[sender identifier] isEqualToString:@"contentViewButton"]){
//        [_tabView selectTabViewItemWithIdentifier:@"styled"];
//
//        // Convert HTML to Markdown
//        NSArray *selected = [_entriesArrayController selectedObjects];
//        if (selected && [selected count] == 1) {
//            Entry *selectedEntry = [selected objectAtIndex:0];
//            if ([selectedEntry content]) {
//                NSString *html = @(markdown_to_string((char *)[[selectedEntry content] UTF8String],EXT_NOTES + EXT_NO_METADATA,0));
//                [selectedEntry setValue:html forKey:@"html"];
//                [self loadHTMLWithStyle:html];
//            }
//        }
//    }
}
@end
