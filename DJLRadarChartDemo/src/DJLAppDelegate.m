//
//  DJLAppDelegate.m
//  DJLRadarChartDemo
//
//  Created by Dominick Lim on 6/19/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLAppDelegate.h"
#import "DJLMainVC.h"

@implementation DJLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[DJLMainVC alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
