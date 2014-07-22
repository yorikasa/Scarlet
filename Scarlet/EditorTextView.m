//
//  EditorTextView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/18/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "EditorTextView.h"
#import "ScarletAppDelegate.h"
#import "VerticalListViewController.h"
#import "Entry.h"

@implementation EditorTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [self setAutomaticQuoteSubstitutionEnabled:NO];
    [self setAutomaticLinkDetectionEnabled:NO];
    [self setAutomaticDashSubstitutionEnabled:NO];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

}

- (void)paste:(id)sender{
    // see pasteboard later
    [self pasteAsPlainText:sender];
}

#pragma mark - Drag & Drop Operations

//- (void)updateDragTypeRegistration{
//    [self unregisterDraggedTypes];
//    [self registerForDraggedTypes:@[NSPasteboardTypeString, NSPasteboardTypePNG]];
//}

//- (NSArray *)acceptableDragTypes{
//    return @[NSPasteboardTypeString,NSPasteboardTypePNG];
//}

- (NSDragOperation)dragOperationForDraggingInfo:(id <NSDraggingInfo>)dragInfo type:(NSString *)type{
    [super dragOperationForDraggingInfo:dragInfo type:type];

    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

    sourceDragMask = [dragInfo draggingSourceOperationMask];
    pboard = [dragInfo draggingPasteboard];

    // Are you local file?
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSURL *url = [NSURL URLFromPasteboard:pboard];

        // then, image file?
        NSError *error = NULL;
        NSRegularExpression *imageExtensions = [NSRegularExpression regularExpressionWithPattern:@"jpg|jpeg|gif|png|psd|tiff|svg|pdf|bmp" options:NSRegularExpressionCaseInsensitive error:&error];
        if ([imageExtensions numberOfMatchesInString:[url pathExtension]
                                             options:0
                                               range:NSMakeRange(0, [[url pathExtension] length])]) {
            if (sourceDragMask & NSDragOperationCopy) {
                return NSDragOperationCopy;
            }else if (sourceDragMask & NSDragOperationLink){
                return NSDragOperationLink;
            }
        }else{ // not image file? GET OUT
            return NSDragOperationNone;
        }
    }

    // Or image?
    if ([[pboard types] containsObject:NSPasteboardTypeTIFF]) {
        if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }else if (sourceDragMask & NSDragOperationLink){
            return NSDragOperationLink;
        }
    }

    // Or dragging string?
    if ([[pboard types] containsObject:NSPasteboardTypeString]) {
        if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }

    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];

    NSURL *url = [NSURL URLFromPasteboard:pboard];
    NSURL *writeURL = [[self imageDirectoryURLForEntry] URLByAppendingPathComponent:[url lastPathComponent]];
    // Local files.
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        // then, image file?
        NSError *error = NULL;
        NSRegularExpression *imageExtensions = [NSRegularExpression regularExpressionWithPattern:@"jpg|jpeg|gif|png|psd|tiff|svg|pdf|bmp" options:NSRegularExpressionCaseInsensitive error:&error];
        if ([imageExtensions numberOfMatchesInString:[url pathExtension]
                                             options:0
                                               range:NSMakeRange(0, [[url pathExtension] length])]) {
            // do you want to copy?
            if (sourceDragMask & NSDragOperationCopy) {
                // Copy the user-specified file to the directory just created
                if ([self copyFiletoURL:writeURL fromURL:url]) {
                    [self insertText:[NSString stringWithFormat:@"![](%@)", [writeURL absoluteString]]];
                    return YES;
                }else{
                    return NO;
                }
            }else if (sourceDragMask & NSDragOperationLink){
                //Just copy url. done.
                [self insertText:[NSString stringWithFormat:@"![](%@)", [url absoluteString]]];
                return YES;
            }
        }else{ // not image file? GET OUT
            return NO;
        }
    }

    // OK. Dragging image directly.
    if ([[pboard types] containsObject:NSPasteboardTypeTIFF]) {
        if (sourceDragMask & NSDragOperationCopy){
            NSURL *webURL = [NSURL URLWithString:[pboard readObjectsForClasses:@[[NSString class]] options:nil][0]];
            [self downloadImageToURL:writeURL FromURL:webURL];
            // Oh, you always say 'yes' whether download success or not (error handling needed)
            return YES;
        }else if (sourceDragMask & NSDragOperationLink){
            NSString *urlString = [pboard readObjectsForClasses:@[[NSString class]] options:nil][0];
            [self insertText:[NSString stringWithFormat:@"![](%@)", urlString]];
            return YES;
        }
    }

    if ([[pboard types] containsObject:NSPasteboardTypeString]) {
        // simple string. paste the string. done.
        [self insertText:[pboard readObjectsForClasses:@[[NSString class]] options:nil][0]];
        return YES;
    }
    return NO; // just in case.
}

- (NSURL *)imageDirectoryURLForEntry{
    // Add this entry's creation date to directory name
    NSDate *entryDate = [[[[[NSApp delegate] verticalListViewController] entryArrayController] selectedObjects][0] dateCreated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:entryDate];
    NSURL *imageDirectory = [[[NSApp delegate] applicationFilesDirectory]
                             URLByAppendingPathComponent:[NSString stringWithFormat:@"Images/%@", dateString]];
    NSError *error;
    BOOL ok = YES;
    // Create a folder (or, attempt to create)
    ok = [[NSFileManager defaultManager] createDirectoryAtURL:imageDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (!ok) {
        NSLog(@"Cannot create directory");
        NSLog(@"%@", error);
    }
    return imageDirectory;
}

- (BOOL)copyFiletoURL:(NSURL *)destURL fromURL:(NSURL *)srcURL{
    BOOL ok = YES;
    NSError *error = NULL;
    if ([[NSFileManager defaultManager] isReadableFileAtPath:[srcURL path]]) {
        ok = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
        // Oh, cannnot copied?
        if (!ok) {
            // Same name file exists
            if (error.code == 516 && [error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
                BOOL sure = 0;
                int i = 1;
                NSString *lastPathComponent = [destURL lastPathComponent];
                NSString *extension = [destURL pathExtension];
                NSString *fileName = [lastPathComponent substringToIndex:[lastPathComponent length]-[extension length]-1];
                while (!sure && i < 1000) {
                    NSString *newLastPath = [NSString stringWithFormat:@"%@-%i.%@", fileName, i, extension];
                    destURL = [destURL URLByDeletingLastPathComponent];
                    destURL = [destURL URLByAppendingPathComponent:newLastPath];
                    sure = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
                    i++;
                }
            }else{
                NSLog(@"cant copy");
                NSLog(@"%@", error);
                return NO;
            }
        }
        return YES;
    }else{
        NSLog(@"not readable or writable");
    }
    return NO;
}

- (void)downloadImageToURL:(NSURL *)destURL FromURL:(NSURL *)srcURL{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:srcURL];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:req completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if ([self copyFiletoURL:destURL fromURL:location]) {
            NSLog(@"So far so good.");
            // This should not be here, but I cannot think of good idea.
            [self insertText:[NSString stringWithFormat:@"![](%@)", [destURL absoluteString]]];
        }else{
            NSLog(@"Bad things happen.");
        }
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    [downloadTask resume];
}


@end
