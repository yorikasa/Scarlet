//
//  ScarletAppDelegate.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/23/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "ScarletAppDelegate.h"
#import "libMultiMarkdown.h"
#import "VerticalListViewController.h"
#import "Entry.h"
#import "Box.h"
#import "TagTableViewController.h"
#import "PreferenceWindowController.h"

@implementation ScarletAppDelegate{
    PreferenceWindowController *_preferenceWindowController;
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self makeDefaultInbox];

    _viewControllers = [[NSMutableArray alloc] init];
    _verticalListViewController = [[VerticalListViewController alloc] init];
    [_viewControllers addObject:_verticalListViewController];

    // Load vertical list view with Constraints
    NSView *verticalListView = [_verticalListViewController view];
    [_contentView replaceSubview:_blankView with:verticalListView];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(verticalListView);
    NSArray *cv = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[verticalListView]|"
                                                                     options:0 metrics:nil views:viewsDictionary];
    NSArray *ch = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[verticalListView]|"
                                                          options:0 metrics:nil views:viewsDictionary];
    [_contentView addConstraints:cv];
    [_contentView addConstraints:ch];

    [self prepareSort];

    // Sidebar something
    if ([_splitView isSubviewCollapsed:[_splitView subviews][0]]) {
        [_toggleSidebarButton setState:NO];
    }else{
        [_toggleSidebarButton setState:YES];
        [self swapButtonImages:_toggleSidebarButton];
    }
}

+ (void)initialize{
    // Set factory defaults
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

    [defaults setObject:@"LucidaGrande" forKey:DefaultEditorFontName];
    [defaults setObject:@13 forKey:DefaultEditorFontSize];

    NSData *foregroundColorAsData = [NSArchiver archivedDataWithRootObject:[NSColor blackColor]];
    [defaults setObject:foregroundColorAsData forKey:DefaultEditorForegroundColor];
    NSData *backgroundColorAsData = [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]];
    [defaults setObject:backgroundColorAsData forKey:DefaultEditorBackgroundColor];
    NSData *insertionColorAsData = [NSArchiver archivedDataWithRootObject:[NSColor blackColor]];
    [defaults setObject:insertionColorAsData forKey:DefaultEditorInsertionColor];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.yorikasa.Scarlet" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.yorikasa.Scarlet"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Scarlet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Scarlet.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

    NSDictionary *optionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:optionDictionary error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.

    if (!_managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];

        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

#pragma mark - Split View Delegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview{
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex{
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex{
    return YES;
}

#pragma mark - Outline View Delegate

- (id)outlineView:(NSOutlineView *)ov viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    if ([[item representedObject] isLeaf] == NO) {
        return [ov makeViewWithIdentifier:@"HeaderCell" owner:self];
    }else{
        return [ov makeViewWithIdentifier:@"DataCell" owner:self];
    }
}

#pragma mark - Table View Sorting

- (void)setSortDescriptorsWithKey:(NSString *)key ascending:(BOOL)order option:(BOOL)option{
    if (option) {
        [[_verticalListViewController entryArrayController] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:order selector:@selector(caseInsensitiveCompare:)]]];
    }
    else{
        [[_verticalListViewController entryArrayController] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:order]]];
    }
}

- (void)prepareSort{
    BOOL option;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] isEqualToString:@"title"]) {
        option = YES;
        [_menuSortByTitle setState:NSOnState];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] isEqualToString:@"dateCreated"]){
        [_menuSortByDateCreated setState:NSOnState];
        option = NO;
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] isEqualToString:@"dateModified"]){
        [_menuSortByDateModified setState:NSOnState];
        option = NO;
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
        option = NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sortAscending"]) {
        [_menuSortAscending setState:NSOnState];
    }
    else{
        [_menuSortDescending setState:NSOnState];
    }
    
    [self setSortDescriptorsWithKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"sortBy"] ascending:[[NSUserDefaults standardUserDefaults] boolForKey:@"sortAscending"] option:option];
}

#pragma mark - Actions

- (IBAction)changeSort:(id)sender{
    BOOL order;
    if ([_menuSortAscending state] == 1) {
        order = YES;
    }else{
        order = NO;
    }

    if (sender == _menuSortByDateCreated) {
        [[_verticalListViewController entryArrayController] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:order]]];
        [_menuSortByDateCreated setState:NSOnState];
        [_menuSortByDateModified setState:NSOffState];
        [_menuSortByTitle setState:NSOffState];
        [[NSUserDefaults standardUserDefaults] setObject:@"dateCreated" forKey:@"sortBy"];
        [[NSUserDefaults standardUserDefaults] setBool:order forKey:@"sortAscending"];
    }
    else if (sender == _menuSortByDateModified){
        [[_verticalListViewController entryArrayController] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateModified" ascending:order]]];
        [_menuSortByDateCreated setState:NSOffState];
        [_menuSortByDateModified setState:NSOnState];
        [_menuSortByTitle setState:NSOffState];
        [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
        [[NSUserDefaults standardUserDefaults] setBool:order forKey:@"sortAscending"];
    }
    else if (sender == _menuSortByTitle){
        [[_verticalListViewController entryArrayController] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:order selector:@selector(caseInsensitiveCompare:)]]];
        [_menuSortByDateCreated setState:NSOffState];
        [_menuSortByDateModified setState:NSOffState];
        [_menuSortByTitle setState:NSOnState];
        [[NSUserDefaults standardUserDefaults] setObject:@"title" forKey:@"sortBy"];
        [[NSUserDefaults standardUserDefaults] setBool:order forKey:@"sortAscending"];
    }
}

- (IBAction)changeOrder:(id)sender{
    if (sender == _menuSortAscending) {
        [_menuSortAscending setState:NSOnState];
        [_menuSortDescending setState:NSOffState];

        if ([_menuSortByTitle state] == 1) {
            [self setSortDescriptorsWithKey:@"title" ascending:YES option:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"title" forKey:@"sortBy"];
        }
        else if ([_menuSortByDateCreated state] == 1){
            [self setSortDescriptorsWithKey:@"dateCreated" ascending:YES option:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"dateCreated" forKey:@"sortBy"];
        }
        else if ([_menuSortByDateModified state] == 1){
            [self setSortDescriptorsWithKey:@"dateModified" ascending:YES option:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sortAscending"];
    }
    else if (sender == _menuSortDescending){
        [_menuSortAscending setState:NSOffState];
        [_menuSortDescending setState:NSOnState];

        if ([_menuSortByTitle state] == 1) {
            [self setSortDescriptorsWithKey:@"title" ascending:NO option:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"title" forKey:@"sortBy"];
        }
        else if ([_menuSortByDateCreated state] == 1){
            [self setSortDescriptorsWithKey:@"dateCreated" ascending:NO option:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"dateCreated" forKey:@"sortBy"];
        }
        else if ([_menuSortByDateModified state] == 1){
            [self setSortDescriptorsWithKey:@"dateModified" ascending:NO option:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"dateModified" forKey:@"sortBy"];
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sortAscending"];
    }
}

#pragma mark - Actions

- (IBAction)addOrRemoveEntry:(id)sender {
    switch ([sender selectedSegment]) {
        case 0:
            [[_verticalListViewController entryArrayController] add:sender];
            break;
        case 1:
            [[_verticalListViewController entryArrayController] remove:sender];
            break;
    }
}

- (void)search:(id)sender{
    NSString *string = [_searchField stringValue];
    NSPredicate *predicate;

    if (![string isEqualToString:@""]) {
        NSArray *terms = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        NSPredicate *predicateForContent;
        NSMutableArray *subPredicatesForContent = [[NSMutableArray alloc] init];
        for(NSString *term in terms) {
            if([term length] == 0) { continue; }
            NSPredicate *p = [NSPredicate predicateWithFormat:@"content contains[cd] %@", term];
            [subPredicatesForContent addObject:p];
        }
        predicateForContent = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicatesForContent];

        NSPredicate *predicateForTitle;
        NSMutableArray *subPredicatesForTitle = [[NSMutableArray alloc] init];
        for(NSString *term in terms) {
            if([term length] == 0) { continue; }
            NSPredicate *p = [NSPredicate predicateWithFormat:@"title contains[cd] %@", term];
            [subPredicatesForTitle addObject:p];
        }
        predicateForTitle = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicatesForTitle];

        NSPredicate *predicateForBox;
        NSMutableArray *subPredicatesForBox = [[NSMutableArray alloc] init];
        for(NSString *term in terms) {
            if([term length] == 0) { continue; }
            NSPredicate *p = [NSPredicate predicateWithFormat:@"box.name contains[cd] %@", term];
            [subPredicatesForBox addObject:p];
        }
        predicateForBox = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicatesForBox];

        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicateForContent, predicateForTitle, predicateForBox]];
    }
    [[_verticalListViewController entryArrayController] setFilterPredicate:predicate];
}

- (IBAction)toggleSidebar:(id)sender {
    [self swapButtonImages:sender];

    if ([sender state] == NSOnState) {
        //[self expandSidebar];
        [_sourceView setHidden:NO];
    }else{
        //[self collapseSidebar];
        [_sourceView setHidden:YES];
    }
    [_splitView adjustSubviews];
}

#pragma mark - Menu bar

- (IBAction)menuBarNew:(id)sender {
    [[_verticalListViewController entryArrayController] add:sender];
}

- (IBAction)showPreferenceWindow:(id)sender {
    if (!_preferenceWindowController) {
        _preferenceWindowController = [[PreferenceWindowController alloc] init];
    }
    [_preferenceWindowController showWindow:self];
}

#pragma mark -

- (void)makeDefaultInbox{
    //Find "Inbox" box. If there's not, create one.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Box" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name LIKE 'Inbox'"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        if ([array count] == 0) {
            NSEntityDescription *boxEntity = [NSEntityDescription entityForName:@"Box" inManagedObjectContext:_managedObjectContext];
            Box *newBox = [[Box alloc] initWithEntity:boxEntity insertIntoManagedObjectContext:_managedObjectContext];
            [newBox setName:@"Inbox"];
        }
    }
    else{
        // error handling
    }
}

-(void)swapButtonImages: (id)sender{
    NSImage *tmpImage = [sender image];
    [sender setImage:[sender alternateImage]];
    [sender setAlternateImage:tmpImage];
}

- (void)collapseSidebar{
//    NSView *left  = [_splitView subviews][0];
//    NSView *right = [_splitView subviews][1];
//    NSRect rightFrame = [right frame];
//    NSRect overallFrame = [_splitView frame]; //???
//    [left setHidden:YES];
//    [right setFrameSize:NSMakeSize(overallFrame.size.width, rightFrame.size.height)];
//    [_splitView display];
}

- (void)expandSidebar{

}














@end
