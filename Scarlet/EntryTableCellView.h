//
//  EntryTableCellView.h
//  Scarlet
//
//  Created by Yuki Orikasa on 7/10/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EntryTableCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTextField *tagsTextField;
@property (weak) IBOutlet NSTextField *dateTextField;

@end
