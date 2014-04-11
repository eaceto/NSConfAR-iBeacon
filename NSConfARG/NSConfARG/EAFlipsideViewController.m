//
//  EAFlipsideViewController.m
//  NSConfARG
//
//  Created by Kimi on 27/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EAFlipsideViewController.h"

@interface EAFlipsideViewController ()

@end

@implementation EAFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];    
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)cleanPrefs:(id)sender
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:@"identifier"];
    [defs removeObjectForKey:@"username"];
    [defs removeObjectForKey:@"name"];        
    [defs removeObjectForKey:@"didCheckin"];
    [defs removeObjectForKey:@"checkin"];
    [defs synchronize];
}


@end
