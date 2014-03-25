//
//  EABroadcasterTableViewCell.m
//  Broadcaster
//
//  Created by Kimi on 25/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EABroadcasterTableViewCell.h"

@implementation EABroadcasterTableViewCell
@synthesize beaconIDLabel,beaconName,beaconSwitch;
@synthesize beaconDelegate, beacon;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setBeaconDelegate:(id<EABroadcasterCellProtocol>)delegate;
{
    beaconDelegate = delegate;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)beaconSwitchHasChanged:(id)sender
{
    
}

- (void)setBeacon:(NSDictionary *)_beacon
{
    beacon = _beacon;
    [beaconName setText:[beacon objectForKey:@"name"]];
    [beaconIDLabel setText:[beacon objectForKey:@"id"]];
    [beaconSwitch setOn:[[beacon objectForKey:@"state"] boolValue]];
}

@end
