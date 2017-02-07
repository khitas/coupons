//
//  TermsViewController.h
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clsOffer.h"


@interface TermsViewController : UIViewController
{
    clsOffer *offer;
    
    IBOutlet UITextView *lblCouponTerms;
}

@property (nonatomic, strong) clsOffer *offer;

@property (nonatomic, strong) IBOutlet UITextView *lblCouponTerms;


-(void)showData;


@end
