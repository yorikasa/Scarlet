//
//  TableController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 8/8/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "ScarletAppDelegate.h"
#import "TableController.h"
#import "ContentController.h"
#import "Entry.h"
#import "EntryTableCellView.h"

@implementation TableController

- (void)setSortDescriptorsWithKey:(NSString *)key ascending:(BOOL)order option:(BOOL)option{
//    if (option) {
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:order selector:@selector(caseInsensitiveCompare:)]]];
//    }
//    else{
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:order]]];
//    }
}

- (void)prepareSort{
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
}

#pragma mark - Actions

- (IBAction)changeSort:(id)sender{
//    BOOL order;
//    if ([_menuSortAscending state] == 1) {
//        order = YES;
//    }else{
//        order = NO;
//    }
//
//    if (sender == _menuSortByDateCreated) {
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:order]]];
//        [_menuSortByDateCreated setState:NSOnState];
//        [_menuSortByDateModified setState:NSOffState];
//        [_menuSortByTitle setState:NSOffState];
//        [[NSUserDefaults standardUserDefaults] setObject:@"dateCreated" forKey:@"sortBy"];
//        [[NSUserDefaults standardUserDefaults] setBool:order forKey:@"sortAscending"];
//    }
//    else if (sender == _menuSortByDateModified){
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateModified" ascending:order]]];
//        [_menuSortByDateCreated setState:NSOffState];
//        [_menuSortByDateModified setState:NSOnState];
//        [_menuSortByTitle setState:NSOffState];
//        [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
//        [[NSUserDefaults standardUserDefaults] setBool:order forKey:@"sortAscending"];
//    }
//    else if (sender == _menuSortByTitle){
//        [_entriesArrayController setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:order selector:@selector(caseInsensitiveCompare:)]]];
//        [_menuSortByDateCreated setState:NSOffState];
//        [_menuSortByDateModified setState:NSOffState];
//        [_menuSortByTitle setState:NSOnState];
//        [[NSUserDefaults standardUserDefaults] setObject:@"title" forKey:@"sortBy"];
//        [[NSUserDefaults standardUserDefaults] setBool:order forKey:@"sortAscending"];
//    }
}

- (IBAction)changeOrder:(id)sender{
//    if (sender == _menuSortAscending) {
//        [_menuSortAscending setState:NSOnState];
//        [_menuSortDescending setState:NSOffState];
//
//        if ([_menuSortByTitle state] == 1) {
//            [self setSortDescriptorsWithKey:@"title" ascending:YES option:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:@"title" forKey:@"sortBy"];
//        }
//        else if ([_menuSortByDateCreated state] == 1){
//            [self setSortDescriptorsWithKey:@"dateCreated" ascending:YES option:NO];
//            [[NSUserDefaults standardUserDefaults] setObject:@"dateCreated" forKey:@"sortBy"];
//        }
//        else if ([_menuSortByDateModified state] == 1){
//            [self setSortDescriptorsWithKey:@"dateModified" ascending:YES option:NO];
//            [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
//        }
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sortAscending"];
//        NSLog(@"Order By: %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"sortAscending"]);
//    }
//    else if (sender == _menuSortDescending){
//        [_menuSortAscending setState:NSOffState];
//        [_menuSortDescending setState:NSOnState];
//
//        if ([_menuSortByTitle state] == 1) {
//            [self setSortDescriptorsWithKey:@"title" ascending:NO option:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:@"title" forKey:@"sortBy"];
//        }
//        else if ([_menuSortByDateCreated state] == 1){
//            [self setSortDescriptorsWithKey:@"dateCreated" ascending:NO option:NO];
//            [[NSUserDefaults standardUserDefaults] setObject:@"dateCreated" forKey:@"sortBy"];
//        }
//        else if ([_menuSortByDateModified state] == 1){
//            [self setSortDescriptorsWithKey:@"dateModified" ascending:NO option:NO];
//            [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
//        }
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sortAscending"];
//        NSLog(@"Order By: %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"sortAscending"]);
//    }
}







@end
