//
//  CompanyViewController.h
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clsCompany.h"

@interface CompanyViewController : UIViewController
{
    clsCompany *company;
    
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblPostalcode;
    IBOutlet UILabel *lblPhone;
    IBOutlet UILabel *lblFax;
    IBOutlet UILabel *lblService_type;
    IBOutlet UILabel *lblAfm;
}

@property (nonatomic, strong) clsCompany *company;

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblAddress;
@property (nonatomic, strong) IBOutlet UILabel *lblPostalcode;
@property (nonatomic, strong) IBOutlet UILabel *lblPhone;
@property (nonatomic, strong) IBOutlet UILabel *lblFax;
@property (nonatomic, strong) IBOutlet UILabel *lblService_type;
@property (nonatomic, strong) IBOutlet UILabel *lblAfm;

-(void)showData;

@end
