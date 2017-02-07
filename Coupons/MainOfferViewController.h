//
//  MainOfferViewController.h
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import "PagerViewController.h"
#import "clsOffer.h"
#import "clsCompany.h"
#import "clsCoupon.h"

@interface MainOfferViewController : PagerViewController 
{
    NSInteger couponID;
    NSInteger parentID;
    NSString *parentName;
    NSString *parentSegue;
    
    clsCoupon *coupon;
    clsOffer *offer;
    clsCompany *company;

    IBOutlet UIBarButtonItem *btnGetCoupon;   
}

@property (assign) NSInteger couponID;
@property (assign) NSInteger parentID;
@property (copy) NSString *parentName;
@property (copy) NSString *parentSegue;

@property (nonatomic, strong) clsCoupon *coupon;
@property (nonatomic, strong) clsOffer *offer;
@property (nonatomic, strong) clsCompany *company;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *btnGetCoupon;

-(void) loadData;
-(void) refresh;

-(IBAction)getCoupon:(id)sender;

@end
