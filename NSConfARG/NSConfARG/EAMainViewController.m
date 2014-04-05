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
    IBOutlet UIView* waitForAutomaticCheckinView;
    
    CLBeaconRegion* beaconRegion;
    
    BOOL insideRoom;
}
@end

@implementation EAMainViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Create Beacon Region
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"E3EAC100-1108-1984-AB1A-255255255E1A"];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"ar.com.nsconf.ibeacons"];
    
    insideRoom = [self isLoggedIn] && [self hasBeenDetectedInsideConferenceRoom];
    
    [waitForAutomaticCheckinView setHidden:YES];    
    
    [
     [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalNotificationReceived:) name:@"didReceiveLocalNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isLoggedIn]) {
        if ([self hasBeenDetectedInsideConferenceRoom])
        {
            [locationManager stopMonitoringForRegion:beaconRegion];
        }
    }
}

- (void)showInsideRoomMessage
{
    [messageLabel setText:@"Gracias por participar de NSConf Argentina. Puede seguirnos en Twitter en @nsconfarg y con el hashtag #NSConfARG"];
}

-(void)onLocalNotificationReceived:(NSNotification*)notification
{
    [self performCheckin];
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
    
    // Create Location Manager
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    if ([self hasBeenDetectedInsideConferenceRoom])
    {
        [self showInsideRoomMessage];
        [waitForAutomaticCheckinView setHidden:YES];
        if ([self checkInDone] == NO) {
            [self performCheckin];
        }
        [locationManager stopMonitoringForRegion:beaconRegion];
    }
    else
    {
        // Register for iBeacon region
        [locationManager startMonitoringForRegion:beaconRegion];
    }
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

- (BOOL)checkInDone
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSNumber* checkin = [defs objectForKey:@"didcheckin"];
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
    
    for (CLBeacon* aBeacon in beacons) {

        if (insideRoom == NO    && ([aBeacon proximity] == CLProximityNear || [aBeacon proximity] == CLProximityImmediate)) {
            
            insideRoom = YES;
            
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            [defs setObject:[NSNumber numberWithBool:YES] forKey:@"checkin"];
            [defs synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self performCheckin];
            });
            
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion: %@",region);
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
    else {
        UILocalNotification* notification = [[UILocalNotification alloc] init];
        
        notification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        notification.alertBody = @"Bienvenido a NSConf Argentina";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = @"Check in";
        notification.hasAction = YES;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    NSLog(@"stopRangingBeaconsInRegion");
}

#pragma mark Automatic Checkin
-(void) performCheckin
{
    insideRoom = YES;
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:[NSNumber numberWithBool:YES] forKey:@"checkin"];
    [defs synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self showInsideRoomMessage];
    });
    @try {
        NSString* accountIdentifier = [defs objectForKey:@"identifier"];
        ACAccountStore* accountStore = [[ACAccountStore alloc] init];
        ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError* error){
            if (granted == NO) {
                
            }
            else if (error != nil) {
                
            }
            else {
                NSArray* accounts = [accountStore accountsWithAccountType:accountType];
                
                for (ACAccount* anAccount in accounts) {
                    if ([accountIdentifier compare:[anAccount identifier]] == NSOrderedSame) {
                        [self sendCheckInTweetWithAccount:anAccount];
                    }
                }
            }
        }];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)sendCheckInTweetWithAccount:(ACAccount*)anAccount
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:[NSNumber numberWithBool:NO] forKey:@"didCheckin"];
    [defs synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [waitForAutomaticCheckinView setHidden:NO];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
        @try {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Estoy en @nsconfarg",@"status", nil];
            
            SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"] parameters:dict];
            
            [slRequest setAccount:anAccount];
            
            [slRequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse, NSError *error){
                NSLog(@"The responseString:%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                NSString* response = nil;
                if (urlResponse) response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                if (error == nil && response) {
                    NSError* anotherError = nil;
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&anotherError];
                    if (dic && anotherError == nil) {
                        
                        BOOL statusDuplicated = NO;
                        
                        NSArray* errors = [dic objectForKey:@"errors"];
                        for (NSDictionary* aTwitterError in errors) {
                            NSNumber* code = [aTwitterError objectForKey:@"code"];
                            if (code && [code intValue] == 187) {
                                statusDuplicated = YES;
                                break;
                            }
                        }
                        
                        
                        if ([dic objectForKey:@"id_str"] || statusDuplicated) {
                            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
                            [defs setObject:[NSNumber numberWithBool:YES] forKey:@"didCheckin"];
                            [defs synchronize];
                            
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                [waitForAutomaticCheckinView setHidden:YES];
                                
                                [[[UIAlertView alloc] initWithTitle:@"NSConfARG" message:@"Ha realizado check-in automaticamente! Gracias!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];                                
                            });
                        }
                    }
                }
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception %@",exception);
        }
        @finally {
            
        }
    });
}

@end
