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

-(void) didLoginWithUsername:(NSString*)username name:(NSString*)name account:(ACAccount*)account;

@end

@interface EALoginTableViewController : UITableViewController
{
    id<EALoginProtocol> delegate;    
}

@property (nonatomic, strong) IBOutlet UITableView* accountsTableView;
@property (assign) id<EALoginProtocol> delegate;
@end
