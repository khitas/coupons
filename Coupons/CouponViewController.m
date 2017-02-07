//
//  CouponViewController.m
//  Coupons
//
//  Created by Chytas Constantinos on 7/29/12.
//
//

#import "CouponViewController.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

@synthesize coupon;

@synthesize lblName;
@synthesize lblTitle;
@synthesize lblSerialNumber;
@synthesize lblCreated;


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
    [lblTitle setText:[NSString stringWithFormat:@"%@\n\n\n", [coupon title]]];
    [lblName setText:[NSString stringWithFormat:@"%@\n\n\n", [coupon name]]];
    [lblCreated setText:[coupon created]];
    [lblSerialNumber setText:[coupon serial_number]];
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
