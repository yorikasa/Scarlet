//
//  ExpandedViewController.m
//  Scarlet
//
//  Created by Yuki Orikasa on 7/2/14.
//  Copyright (c) 2014 Yuki Orikasa. All rights reserved.
//

#import "ExpandedViewController.h"

@interface ExpandedViewController ()

@end

@implementation ExpandedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"ExpandedView" bundle:nil];
    if (self){
        // Further initialization if needed
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

@end
