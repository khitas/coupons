//
//  AppDelegate.m
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "clsSettings.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize DBServerLink;
@synthesize SortValues;
@synthesize SortKeys;
@synthesize MapRadiusValues;
@synthesize plistPath;
@synthesize Settings;
@synthesize tabBarController;
@synthesize firstRun;
@synthesize colorRed;
@synthesize colorGreen;
@synthesize colorBlue;
@synthesize colorNone;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    firstRun = YES;
    
    DBServerLink = @"http://coupons.teiath.gr/api";
   
    SortValues = [NSMutableArray arrayWithObjects: @"Πρόσφατες", @"Αξιολόγηση", @"Ψήφοι", @"Απόσταση", nil];
    SortKeys = [NSMutableArray arrayWithObjects: @"recent", @"rank", @"votes", @"distance", nil];

    MapRadiusValues = [NSMutableArray arrayWithObjects: @"1 Km", @"5 Km", @"10 Km", nil];

    plistPath = @"Data.plist";
    
    Settings = [[clsSettings alloc] init];
   
    [Settings Load];
    
    colorRed = [UIColor colorWithRed:238.0f/255.0f green:57.0f/255.0f blue:72.0f/255.0f alpha:1.0f];
    colorGreen = [UIColor colorWithRed:4.0f/255.0f green:128.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
    colorBlue = [UIColor colorWithRed:72.0f/255.0f green:57.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    colorNone = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];

    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
