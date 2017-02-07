//
//  ProfileTableViewController.h
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface ProfileTableViewController : PullRefreshTableViewController
{
    NSString *myCoupons;
    NSString *myVotes;
}

@property (copy) NSString *myCoupons;
@property (copy) NSString *myVotes;

-(void) loadData;
-(IBAction) logout;


@end
