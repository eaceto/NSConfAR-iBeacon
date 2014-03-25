//
//  EABroadcasterTableViewCell.h
//  Broadcaster
//
//  Created by Kimi on 25/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EABroadcasterTableViewCell;
@protocol EABroadcasterCellProtocol <NSObject>

- (void)onBroadcaster:(EABroadcasterTableViewCell*)cell stateChanged:(BOOL)poweredOn;

@end

@interface EABroadcasterTableViewCell : UITableViewCell

@property (nonatomic, assign) id<EABroadcasterCellProtocol> beaconDelegate;
@property (nonatomic, strong) IBOutlet UILabel* beaconIDLabel;
@property (nonatomic, strong) IBOutlet UISwitch* beaconSwitch;
@property (nonatomic, strong) IBOutlet UILabel* beaconName;

@property (nonatomic, strong) NSDictionary* beacon;

- (IBAction)beaconSwitchHasChanged:(id)sender;

@end
