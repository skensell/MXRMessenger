//
//  MXRAppDelegate.m
//  MXRMessenger
//
//  Created by Scott Kensell on 04/18/2017.
//  Copyright (c) 2017 Scott Kensell. All rights reserved.
//

#import "MXRAppDelegate.h"

#import "MXRExampleViewController.h"

@implementation MXRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MXRExampleViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
