//
//  OfferViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clsOffer.h"

@interface OfferViewController : UIViewController
{
    clsOffer *offer;
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblOfferCategory;
    IBOutlet UILabel *lblOfferType;
    IBOutlet UILabel *lblTags;
    IBOutlet UILabel *lblCouponCount;
    IBOutlet UILabel *lblMaxPerStudent;
    IBOutlet UILabel *lblVoteCount;
    IBOutlet UILabel *lblVotePlus;
    IBOutlet UILabel *lblVoteMinus;
    IBOutlet UILabel *lblStudentVote;
}

@property (nonatomic, strong) clsOffer *offer;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDescription;
@property (nonatomic, strong) IBOutlet UILabel *lblOfferCategory;
@property (nonatomic, strong) IBOutlet UILabel *lblOfferType;
@property (nonatomic, strong) IBOutlet UILabel *lblTags;
@property (nonatomic, strong) IBOutlet UILabel *lblCouponCount;
@property (nonatomic, strong) IBOutlet UILabel *lblMaxPerStudent;
@property (nonatomic, strong) IBOutlet UILabel *lblVoteCount;
@property (nonatomic, strong) IBOutlet UILabel *lblVotePlus;
@property (nonatomic, strong) IBOutlet UILabel *lblVoteMinus;
@property (nonatomic, strong) IBOutlet UILabel *lblStudentVote;


-(IBAction)Vote:(id)sender;

-(void)showData;

@end
