//
//  EAFlipsideViewController.h
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAFlipsideViewController;

@protocol EAFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(EAFlipsideViewController *)controller;
@end

@interface EAFlipsideViewController : UIViewController

@property (weak, nonatomic) id <EAFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
