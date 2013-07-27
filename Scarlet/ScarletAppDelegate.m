//
//  ScarletAppDelegate.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/23/13.
//  Copyright (c) 2013 Yuki Orikasa. All rights reserved.
//

#import "ScarletAppDelegate.h"
#import "libMultiMarkdown.h"
#import "Entry.h"

@implementation ScarletAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
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
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:optionDictionary error:&error]) {
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

#pragma mark -

- (void)loadHTMLWithStyle:(NSString *)html{
    NSString *style = @"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />";
    NSString *newHTML = [NSString stringWithFormat:@"%@%@", style, html];
    [[self.styledWebView mainFrame] loadHTMLString:newHTML baseURL:[self applicationFilesDirectory]];
}
#pragma mark My methods

- (IBAction)changeContentTabView:(id)sender {
    if ([[sender identifier] isEqualToString:@"styledViewButton"]) {
        [self.contentTabView selectTabViewItemWithIdentifier:@"editor"];
    }
    else if ([[sender identifier] isEqualToString:@"contentViewButton"]){
        [self.contentTabView selectTabViewItemWithIdentifier:@"styled"];
        
        // Convert HTML to Markdown
        NSArray *selected = [self.entriesArrayController selectedObjects];
        if (selected && [selected count] == 1) {
            Entry *selectedEntry = [selected objectAtIndex:0];
            if ([selectedEntry content]) {
                NSString *html = [NSString stringWithUTF8String:markdown_to_string((char *)[[selectedEntry content] UTF8String],EXT_NOTES,0)];
                [selectedEntry setValue:html forKey:@"html"];
                //[[self.styledWebView mainFrame] loadHTMLString:html baseURL:[NSURL URLWithString:@"/"]];
                [self loadHTMLWithStyle:html];
            }
        }
    }
}

#pragma mark -
#pragma mark TableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    NSArray *selected = [self.entriesArrayController selectedObjects];
    if (selected && [selected count] == 1) {
        Entry *selectedEntry = [selected objectAtIndex:0];
        if ([selectedEntry content]) {
            //[[self.styledWebView mainFrame] loadHTMLString:[selectedEntry html] baseURL:[NSURL URLWithString:@"/"]];
            [self loadHTMLWithStyle:[selectedEntry html]];
        }else{
            //[[self.styledWebView mainFrame] loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
            [self loadHTMLWithStyle:@""];
        }
    }else{
//        [[self.styledWebView mainFrame] loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
        [self loadHTMLWithStyle:@""];
    }
}

#pragma  mark SplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview{
    if ([[subview identifier] isEqualToString:@"sourceView"]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex{
    return YES;
}

// Will Fix in 10.9
//- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview{
//    NSLog(@"%@", [subview identifier]);
//    if ([[subview identifier] isEqualToString:@"contentView"]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

#pragma mark -

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


@end
