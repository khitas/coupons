//
//  CategoriesIndexTableViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface CategoriesIndexTableViewController : PullRefreshTableViewController
{
    NSMutableArray *arrayCategories;
}

@property (copy) NSMutableArray *arrayCategories;

-(void) loadData;

@end
