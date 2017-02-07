//
//  TermsViewController.m
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

@synthesize offer;
@synthesize lblCouponTerms;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self showData];
}

-(void)showData
{
    [lblCouponTerms setText:[NSString stringWithFormat:@"%@", ([[offer coupon_terms] isKindOfClass:[NSNull class]] || ([[offer coupon_terms] length] == 0)) ? @"" : [offer coupon_terms]]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
