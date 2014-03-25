//
//  EAMainViewController.h
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EAFlipsideViewController.h"
#import "EABroadcasterTableViewCell.h"

#import "EAAddBroadcasterTableViewController.h"

@interface EAMainViewController : UIViewController <EAFlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate,EABroadcasterCellProtocol>

@end
