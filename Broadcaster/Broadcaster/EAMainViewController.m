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

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EABroadcasterTableViewCell* cell = (EABroadcasterTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"EABroadcasterTableViewCell"];
    
    if (cell == nil) {
        cell = [[EABroadcasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EABroadcasterTableViewCell"];
    }
    
    [cell setBeacon:[iBeacons objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* beacon = [iBeacons objectAtIndex:indexPath.row];
}

#pragma mark Cell Delegate
- (void)onBroadcaster:(EABroadcasterTableViewCell*)cell stateChanged:(BOOL)poweredOn
{
    NSDictionary* beacon = [cell beacon];
}


#pragma mark Actions
- (IBAction)addBroadcaster:(id)sender
{
    EAAddBroadcasterTableViewController* v = [[EAAddBroadcasterTableViewController alloc] initWithNibName:@"EAAddBroadcasterTableViewController" bundle:nil];
    
    [self presentViewController:v animated:YES completion:^(){}];
}

@end
