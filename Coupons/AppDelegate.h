//
//  AppDelegate.h
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class clsSettings;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *DBServerLink;
    NSMutableArray *SortValues;
    NSMutableArray *SortKeys;
    NSString *plistPath;
    NSMutableArray *MapRadiusValues;
    clsSettings *Settings;
    Boolean firstRun;
    UIColor *colorRed;
    UIColor *colorGreen;
    UIColor *colorBlue;
    UIColor *colorNone;
    
    IBOutlet UITabBarController *tabBarController;    
}

@property (nonatomic, assign) Boolean firstRun;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *DBServerLink;
@property (nonatomic, copy) NSMutableArray *SortValues;
@property (nonatomic, copy) NSMutableArray *SortKeys;
@property (nonatomic, copy) NSMutableArray *MapRadiusValues;
@property (nonatomic, copy) NSString *plistPath;
@property (nonatomic, copy) clsSettings *Settings;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) UIColor *colorRed;
@property (nonatomic, strong) UIColor *colorGreen;
@property (nonatomic, strong) UIColor *colorBlue;
@property (nonatomic, strong) UIColor *colorNone;

@end
