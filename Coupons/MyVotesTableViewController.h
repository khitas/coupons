//
//  MyVotesTableViewController.h
//  Coupons
//
//  Created by Chytas Constantinos on 7/30/12.
//
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface MyVotesTableViewController : PullRefreshTableViewController
{
    NSMutableArray *arrayVotes;
}

@property (copy) NSMutableArray *arrayVotes;

-(void) loadData;
- (IBAction)openDelete:(id)sender;

@end
