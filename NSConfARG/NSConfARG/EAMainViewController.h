//
//  EAMainViewController.h
//  NSConfARG
//
//  Created by Kimi on 27/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EAFlipsideViewController.h"
#import "EALoginTableViewController.h"

#import <CoreLocation/CoreLocation.h>


@interface EAMainViewController : UIViewController <EAFlipsideViewControllerDelegate,EALoginProtocol, CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
}
@property (nonatomic, strong) CLLocationManager* locationManager;

@end
