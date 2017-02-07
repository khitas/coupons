//
//  MyCouponsTableViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface MyCouponsTableViewController : PullRefreshTableViewController
{
    NSMutableArray *arrayCoupons;

    NSInteger RowIndexToDelete;
}

@property (copy) NSMutableArray *arrayCoupons;

-(void) loadData;

- (IBAction)openDelete:(id)sender;

@end
