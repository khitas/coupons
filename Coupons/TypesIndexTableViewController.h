//
//  TypesIndexTableViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface TypesIndexTableViewController : PullRefreshTableViewController
{
   NSMutableArray *arrayTypes;
}

@property (copy) NSMutableArray *arrayTypes;

-(void) loadData;

@end
