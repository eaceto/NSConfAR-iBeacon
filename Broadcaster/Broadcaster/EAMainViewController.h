//
//  EAMainViewController.h
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EAFlipsideViewController.h"

@import CoreBluetooth;
@import CoreLocation;

@interface EAMainViewController : UIViewController <EAFlipsideViewControllerDelegate, UITextFieldDelegate, CBPeripheralManagerDelegate>

-(IBAction)onMeasuredPowerSliderChanged:(id)sender;

@end
