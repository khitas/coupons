//
//  OffersIndexTableViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface OffersIndexTableViewController : PullRefreshTableViewController
{
    NSMutableArray *arrayOffers;

    NSInteger pageID;
    NSInteger parentID;
    NSString *parentName;
    NSString *parentSegue;
    NSString *searchString;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UISegmentedControl *segmentedControl;
}

@property (nonatomic) NSInteger parentID;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *parentSegue;
@property (nonatomic, copy) NSString *searchString;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

-(void) loadData;
-(IBAction)pageChanged:(id)sender;

@end
