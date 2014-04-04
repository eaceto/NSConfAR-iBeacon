//
//  EAAppDelegate.h
//  MacBroadcaster
//
//  Created by Kimi on 03/04/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

@interface EAAppDelegate : NSObject <CBPeripheralManagerDelegate, NSApplicationDelegate>


@property (nonatomic,strong) CBPeripheralManager *manager;
@property (assign) IBOutlet NSWindow *window;

@end
