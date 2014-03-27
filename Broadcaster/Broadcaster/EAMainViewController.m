//
//  EAMainViewController.m
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EAMainViewController.h"

@interface EAMainViewController ()
{
    IBOutlet UILabel* nsconfLabel;

    IBOutlet UITextField* uuidTextField, *majorTextField, *minorTextField;
    IBOutlet UISlider* powerSlider;
    IBOutlet UILabel* measuredPowerLabel;
    IBOutlet UISwitch* broadcasterSwitch;
    
    NSString* iBeaconUUID;
    NSNumber* iBeaconMajor;
    NSNumber* iBeaconMinor;
    NSNumber* iBeaconMeasuredPower;
    
    CBPeripheralManager *peripheralManager;
    CLBeaconRegion *region;
}

@end

@implementation EAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    [uuidTextField becomeFirstResponder];
    
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil]; //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect frame = CGRectMake(nsconfLabel.frame.origin.x, [UIScreen mainScreen].bounds.size.height - nsconfLabel.frame.size.height - 4, nsconfLabel.frame.size.width, nsconfLabel.frame.size.height);
    [nsconfLabel setFrame:frame];
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

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)onMeasuredPowerSliderChanged:(id)sender
{
    [measuredPowerLabel setText:[NSString stringWithFormat:@"%f dB",[powerSlider value]]];
}

-(IBAction)onBroadcasterStateChanged:(id)sender
{
    if ([broadcasterSwitch isOn] == YES) {
        iBeaconUUID = [uuidTextField text];
        NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
        iBeaconMajor = [f numberFromString:[majorTextField text]];
        iBeaconMinor = [f numberFromString:[minorTextField text]];
        iBeaconMeasuredPower = [NSNumber numberWithFloat:[powerSlider value]];
        
        [self startBroadcasting];
    }
    else {
        [self stopBroadcasting];
    }
}

- (void)stopBroadcasting
{
    [uuidTextField resignFirstResponder];
    [majorTextField resignFirstResponder];
    [minorTextField resignFirstResponder];
    [powerSlider resignFirstResponder];
    
    [uuidTextField setEnabled:YES];
    [majorTextField setEnabled:YES];
    [minorTextField setEnabled:YES];
    [powerSlider setEnabled:YES];
    
    [peripheralManager stopAdvertising];
}

- (void)startBroadcasting
{
    [uuidTextField resignFirstResponder];
    [majorTextField resignFirstResponder];
    [minorTextField resignFirstResponder];
    [powerSlider resignFirstResponder];
    
    [uuidTextField setEnabled:NO];
    [majorTextField setEnabled:NO];
    [minorTextField setEnabled:NO];
    [powerSlider setEnabled:NO];
    

    // Verificamos que Bluetooth este encendido
    if(peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Broadcaste" message:@"Bluetooth no esta habilitado. Por favor, habilite Bluetooth en su dispositivo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlertView show];
        
        return;
    }

    // Construimos el UUID
    NSUUID* UUID = [[NSUUID alloc] initWithUUIDString:iBeaconUUID];
    
    // Construimos la región basandonos en el UUID y los números de verions
    region = [[CLBeaconRegion alloc] initWithProximityUUID:UUID major:[iBeaconMajor shortValue] minor:[iBeaconMinor shortValue] identifier:@"BroadcasteriBeacon"];
    
    // Construimos el diccionario con la información del iBeacon a traves de la región que definimos previamoente
    NSDictionary *iBeaconData = [region peripheralDataWithMeasuredPower:iBeaconMeasuredPower];
    
    // Empezamos a transmitir
    [peripheralManager startAdvertising:iBeaconData];
    
    [peripheralManager isAdvertising];
}

#pragma mark Core Bluetooth Peripheral Delegate
- (NSString*)peripherialStateFor:(CBPeripheralManagerState) state
{
    switch (state) {
        case CBPeripheralManagerStatePoweredOff: return @"CBPeripheralManagerStatePoweredOff";
        case CBPeripheralManagerStateResetting: return @"CBPeripheralManagerStateResetting";
        case CBPeripheralManagerStatePoweredOn: return @"CBPeripheralManagerStatePoweredOn";
        case CBPeripheralManagerStateUnauthorized: return @"CBPeripheralManagerStateUnauthorized";
        case CBPeripheralManagerStateUnknown: return @"CBPeripheralManagerStateUnknown";
        default: return @"CBPeripheralManagerStateUnsupported";
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"%@ - %@: %@ - %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd), [self peripherialStateFor:[peripheral state]], [peripheral isAdvertising]?@"Advertising":@"Advertising stopped");
    
    if ([peripheral isAdvertising] == NO) [broadcasterSwitch setOn:NO animated:YES];
    else [broadcasterSwitch setOn:YES animated:YES];
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@ - %@: Error %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd),error);
}


@end
