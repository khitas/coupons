//
//  SettingsTypesOrderByTableViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsOrderByTableViewController : UITableViewController
{
    NSString *parentSegue;
}

@property (nonatomic, copy) NSString *parentSegue;

@end