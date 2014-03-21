//
//  EABeaconsHelper.h
//  Broadcaster
//
//  Created by Kimi on 21/03/2014.
//  Copyright (c) 2014 NSConfARG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EABeaconsHelper : NSObject

+ (NSDictionary*)allBeacons;

+ (void)addBeacon:(NSDictionary*)beacon;

+ (void)removeBeaconWithUDID:(NSString*)udid;

+ (void)removeAllBeacons;

+ (void)saveBeacons:(NSDictionary*)dic;

@end
