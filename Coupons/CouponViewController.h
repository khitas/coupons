//
//  CouponViewController.h
//  Coupons
//
//  Created by Chytas Constantinos on 7/29/12.
//
//

#import <UIKit/UIKit.h>
#import "clsCoupon.h"

@interface CouponViewController : UIViewController
{
    clsCoupon *coupon;
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblSerialNumber;
    IBOutlet UILabel *lblCreated;
}

@property (nonatomic, strong) clsCoupon *coupon;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblSerialNumber;
@property (nonatomic, strong) IBOutlet UILabel *lblCreated;

-(void)showData;

@end