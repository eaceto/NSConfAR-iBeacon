//
//  EAMainViewController.m
//  NSConfARG
//
//  Created by Kimi on 27/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EAMainViewController.h"

@interface EAMainViewController ()
{
    IBOutlet UILabel* messageLabel;
    CLBeaconRegion* beaconRegion;
}
@end

@implementation EAMainViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Create Location Manager
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    // Create Beacon Region
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"E3EAC100-1108-1984-AB1A-255255255E1A"];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"NSConfARG Room"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self hasBeenDetectedInsideConferenceRoom])
    {
        [messageLabel setText:@"Gracias por participar de NSConf Argentina. Puede seguirnos en Twitter en @nsconfarg y con el hashtag #NSConfARG"];
        
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
    else
    {
        // Register for iBeacon region
        [locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self isLoggedIn] == NO)
    {
        EALoginTableViewController* login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EALoginTableViewController"];
        [self presentViewController:login animated:YES completion:^(){}];
        [login setDelegate:self];
        return;
    }
    
    [super viewDidAppear:animated];
}

- (BOOL) isLoggedIn
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSString* username = [defs objectForKey:@"username"];
    if (username != nil && [@"" compare:username] != NSOrderedSame) return YES;
    return NO;
}

- (BOOL)hasBeenDetectedInsideConferenceRoom
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSNumber* checkin = [defs objectForKey:@"checkin"];
    if (checkin != nil) return [checkin boolValue];
    return NO;
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

#pragma mark User login
- (void)didLoginWithUsername:(NSString *)username name:(NSString *)name account:(ACAccount*)account
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:username forKey:@"username"];
    [defs setObject:name forKey:@"name"];
    [defs setObject:[account identifier] forKey:@"identifier"];
    [defs synchronize];    
}

#pragma mark Core Location
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"didRangeBeacons: %@ in Region: %@",beacons,region);
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    NSLog(@"rangingBeaconsDidFailForRegion: %@ in Region: %@",error,region);
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion: %@",region);
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion: %@",region);
}

@end
