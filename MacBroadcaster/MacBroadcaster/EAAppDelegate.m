//
//  EAAppDelegate.m
//  MacBroadcaster
//
//  Created by Kimi on 03/04/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EAAppDelegate.h"

@implementation EAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _manager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                       queue:nil];
    
    [_powerButton setEnabled:NO];
    
    [self performSelector:@selector(checkAdvertising:) withObject:nil afterDelay:1.0];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerDidUpdateState: %@",peripheral);
    
    if ([peripheral state] == CBPeripheralManagerStatePoweredOn) {
        [_powerButton setEnabled:YES];
    }
}

-(void)checkAdvertising:(id)i
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [_advertisingButton setState:[_manager isAdvertising]];
    });
    
    [self performSelector:@selector(checkAdvertising:) withObject:nil afterDelay:1.0];
}

- (void)startBroadcasting
{
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:@"E3EAC100-1108-1984-AB1A-255255255E1A"];
    
    NSDictionary *beaconDic = [self beaconAdvertisementWithUUID:beaconUUID major:127 minor:15 measuredPower:0xBA];
    
    [_manager startAdvertising:beaconDic];
}

- (NSDictionary *)beaconAdvertisementWithUUID:(NSUUID*)uuid major:(int16_t)major minor:(int16_t)minor measuredPower:(int8_t)measuredPower
{
    NSString *beaconKey = @"kCBAdvDataAppleBeaconKey";
    
    unsigned char advertisementBytes[21] = {0};
    
    [uuid getUUIDBytes:(unsigned char *)&advertisementBytes];
    
    advertisementBytes[16] = (unsigned char)(major >> 8);
    advertisementBytes[17] = (unsigned char)(major & 255);
    
    advertisementBytes[18] = (unsigned char)(minor >> 8);
    advertisementBytes[19] = (unsigned char)(minor & 255);
    
    advertisementBytes[20] = measuredPower;
    
    NSMutableData *advertisement = [NSMutableData dataWithBytes:advertisementBytes length:21];
    
    return [NSDictionary dictionaryWithObject:advertisement forKey:beaconKey];
}

- (IBAction)onPowerButtonChanged:(id)sender
{
    if ([_powerButton state] == YES)
    {
        [self startBroadcasting];
    }
    else
    {
        [_manager stopAdvertising];
    }
}





@end
