//
//  MXRAppDelegate.m
//  MXRMessenger
//
//  Created by Scott Kensell on 04/18/2017.
//  Copyright (c) 2017 Scott Kensell. All rights reserved.
//

#import "AppDelegate.h"

#import "ChatsListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[ChatsListViewController new]];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
