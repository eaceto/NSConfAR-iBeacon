//
//  EAAddBroadcasterTableViewController.m
//  Broadcaster
//
//  Created by Kimi on 25/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EAAddBroadcasterTableViewController.h"

@interface EAAddBroadcasterTableViewController ()
{
    IBOutlet UITableView* tableView;
}
@end

@implementation EAAddBroadcasterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma marck action
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (IBAction)save:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];    
}
    

@end
