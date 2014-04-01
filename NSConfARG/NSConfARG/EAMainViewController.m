//
//  EAMainViewController.m
//  NSConfARG
//
//  Created by Kimi on 27/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EAMainViewController.h"

@interface EAMainViewController ()

@end

@implementation EAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self isLoggedIn] == NO)
    {
        EALoginTableViewController* login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EALoginTableViewController"];
        [self presentViewController:login animated:YES completion:^(){}];
        return;
    }
    
    [super viewDidAppear:animated];
}

- (BOOL) isLoggedIn
{
    return NO;
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

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(EAFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
