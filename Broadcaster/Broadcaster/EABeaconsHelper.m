//
//  EABeaconsHelper.m
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import "EABeaconsHelper.h"

@implementation EABeaconsHelper

+ (NSDictionary*)allBeacons
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [defs objectForKey:@"iBeacons"];
    
    if (dic == nil) { dic = @{}; }
    
    return dic;
}

+ (void)addBeacon:(NSDictionary*)beacon
{
    NSMutableDictionary* dic = [[EABeaconsHelper allBeacons] mutableCopy];
    [dic setObject:beacon forKey:[beacon objectForKey:@"UDID"]];
    [EABeaconsHelper saveBeacons:dic];
}

+ (void)removeBeaconWithUDID:(NSString*)udid
{
    NSMutableDictionary* dic = [[EABeaconsHelper allBeacons] mutableCopy];
    [dic removeObjectForKey:udid];
    [EABeaconsHelper saveBeacons:dic];
}

+ (void)removeAllBeacons
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:@"iBeacons"];
    [defs synchronize];
}

+ (void)saveBeacons:(NSDictionary*)dic
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:dic forKey:@"iBeacons"];
    [defs synchronize];
}

@end
