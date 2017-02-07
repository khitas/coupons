//
//  CompanyViewController.m
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

@synthesize company;

@synthesize lblName;
@synthesize lblAddress;
@synthesize lblPostalcode;
@synthesize lblPhone;
@synthesize lblFax;
@synthesize lblService_type;
@synthesize lblAfm;

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
    [lblName setText:[NSString stringWithFormat:@"%@\n\n\n", [company name]]];
    
    [lblAddress setText:[company address]];
    [lblPostalcode setText:[company postalcode]];
    [lblPhone setText:[company phone]];
    [lblFax setText:[company fax]];
    [lblService_type setText:[company service_type]];
    [lblAfm setText:[company afm]];

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
