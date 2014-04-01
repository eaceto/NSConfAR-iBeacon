//
//  EALoginTableViewController.h
//  NSConfARG
//
//  Created by Kimi on 27/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Social;
@import Accounts;

@protocol EALoginProtocol <NSObject>

-(void) didLoginWithUsername:(NSString*)username;

@end

@interface EALoginTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITableView* accountsTableView;

@end
