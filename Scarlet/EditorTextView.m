//
//  EditorTextView.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/18/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "EditorTextView.h"

@implementation EditorTextView{
    BOOL isUnregistered;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    isUnregistered = NO;

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
    if ([type isEqualToString:NSFilenamesPboardType]) {
        NSURL *url = [NSURL URLFromPasteboard:pboard];

        // then, image file?
        NSError *error = NULL;
        NSRegularExpression *imageExtensions = [NSRegularExpression regularExpressionWithPattern:@"jpg|jpeg|gif|png|psd|tiff|svg|pdf|bmp" options:NSRegularExpressionCaseInsensitive error:&error];
        if ([imageExtensions numberOfMatchesInString:[url pathExtension]
                                             options:0
                                               range:NSMakeRange(0, [[url pathExtension] length])]) {
            if (sourceDragMask & NSDragOperationCopy) {
                return NSDragOperationCopy;
            }
        }else{ // not image file? GET OUT
            return NSDragOperationNone;
        }
    }

    // Or image?
    if ([[pboard types] containsObject:NSPasteboardTypeTIFF]) {
        if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
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

    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSURL *url = [NSURL URLFromPasteboard:pboard];

        // then, image file?
        NSError *error = NULL;
        NSRegularExpression *imageExtensions = [NSRegularExpression regularExpressionWithPattern:@"jpg|jpeg|gif|png|psd|tiff|svg|pdf|bmp" options:NSRegularExpressionCaseInsensitive error:&error];
        if ([imageExtensions numberOfMatchesInString:[url pathExtension]
                                             options:0
                                               range:NSMakeRange(0, [[url pathExtension] length])]) {
            [self insertText:[NSString stringWithFormat:@"![](%@)", [url absoluteString]]];
            return YES;
        }else{ // not image file? GET OUT
            return NO;
        }
    }

    if ([[pboard types] containsObject:NSPasteboardTypeTIFF]) {
        NSAttributedString *string;
        string = [self attributedStringWithString:@"testtt" image:[[NSImage alloc] initWithPasteboard:pboard] location:nil];
        [self insertText:string];
        //[[self textStorage] appendAttributedString:string];
        return YES;
    }

    if ([[pboard types] containsObject:NSPasteboardTypeString]) {
        [self insertText:[pboard readObjectsForClasses:@[[NSString class]] options:nil][0]];
    }
    return YES;
}

-(NSAttributedString *)attributedStringWithString:(NSString *)string image:(NSImage *)image location:(NSURL *)url{
    NSFileWrapper *wrapper = [[NSFileWrapper alloc] initSymbolicLinkWithDestinationURL:url];
    [wrapper setIcon:image];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];//WithFileWrapper:wrapper];
    NSTextAttachmentCell *cell = [[NSTextAttachmentCell alloc] initImageCell:image];
    [cell setBordered:YES];
    [attachment setAttachmentCell: cell];
    //return [[NSAttributedString alloc] initWithString:string attributes:@{NSAttachmentAttributeName:attachment}];
    return [NSAttributedString attributedStringWithAttachment:attachment];
}


@end
