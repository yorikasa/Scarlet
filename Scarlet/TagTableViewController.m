//
//  TagTableViewController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/14/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "TagTableViewController.h"
#import "TagCellView.h"
#import "Tag.h"
#import "Entry.h"
#import "ScarletAppDelegate.h"
#define NSColorFromRGB(rgbValue) [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface TagTableViewController ()
@end

@implementation TagTableViewController{
    NSPredicate *_searchTagPredicate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    _searchTagPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] $value"];
}

#pragma mark - Table View Delegate & Data Source

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    TagCellView *cell = [tableView makeViewWithIdentifier:@"TagView" owner:self];

    NSAttributedString *tagName = [[NSAttributedString alloc] initWithString:[[_tagArrayController arrangedObjects][row] name]
                                        attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:11],
                                                     NSForegroundColorAttributeName: NSColorFromRGB(0x222222)}];
    [[cell tagName] setAttributedTitle:tagName];
    NSAttributedString *altTagName = [[NSAttributedString alloc] initWithString:[[_tagArrayController arrangedObjects][row] name]
                                        attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:11],
                                          NSForegroundColorAttributeName: NSColorFromRGB(0xaaaaaa)}];
    [[cell tagName] setAttributedAlternateTitle:altTagName];

    [[cell tagName] setState:0];
    if ([[_entryArrayController selectedObjects] count] == 1) {
        for (Tag *tag in [(Entry *)[_entryArrayController selectedObjects][0] tags]) {
            if ([[tag name] isEqualToString:[tagName string]]) {
                [[cell tagName] setState:1];
                continue;
            }
        }
    }
    return cell;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return [[_tagArrayController arrangedObjects] count];
}

#pragma mark - 

- (IBAction)toggleTagState:(id)sender {
    Entry *entry;
    Tag *theTag;
    NSManagedObjectContext *managedObjectContext = [(ScarletAppDelegate *)[NSApp delegate] managedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name LIKE %@", [sender title]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    //Tag *newTag = nil;
    if (array != nil) {
        if ([array count] == 1){
            theTag = array[0];
        }
    }
    else{
        // error handling
    }

    if ([[_entryArrayController selectedObjects] count] == 1) {
        entry = [_entryArrayController selectedObjects][0];
    }

    switch ((NSInteger)[sender state]) {
        case 1:{ // Add
            [entry addTagsObject:array[0]];
            break;
        }case 0: {// Remove
            [entry removeTagsObject:array[0]];
            break;}
    }
    [_tagTableView reloadData];
}

- (void)changePredicate{
    NSString *string = [_searchField stringValue];
    NSPredicate *predicate;
    if (![string isEqualToString:@""]) {
        NSDictionary *dictionary = @{@"value": string};
        predicate = [_searchTagPredicate predicateWithSubstitutionVariables:dictionary];
    }
    [_tagArrayController setFilterPredicate:predicate];
}

- (void)controlTextDidChange:(NSNotification *)aNotification{
    [self changePredicate];
    [_tagTableView reloadData];
}
@end
