//
//  EAMainViewController.m
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EAMainViewController.h"
#import "EABeaconsHelper.h"

@interface EAMainViewController ()
{
    IBOutlet UILabel* nsconfLabel;
    IBOutlet UITableView* tableView;
    
    NSMutableArray* iBeacons;
}

@end

@implementation EAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    iBeacons = [[EABeaconsHelper allBeacons] mutableCopy];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark UI Table View Delegate

#pragma mark UI Table View Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [iBeacons count];
}

@end
