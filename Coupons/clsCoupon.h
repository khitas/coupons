//
//  clsCoupon.h
//  Coupons
//
//  Created by Kwstas Xytas on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsCoupon : NSObject
{
    NSInteger coupon_id;
    NSString *serial_number;
    NSString *created;
    NSInteger reinserted;

    NSInteger offer_id;
    NSString *title;
    NSString *description;
    NSString *coupon_terms;
    NSInteger offer_category_id;
    NSInteger offer_type_id;
    NSInteger vote_count;    
    NSInteger vote_plus;
    NSInteger vote_minus;
    NSString *name;
    NSInteger company_id;
    NSInteger vote_sum;
    NSInteger is_spam;
    NSInteger offer_state_id;

}

@property (assign) NSInteger coupon_id;
@property (copy) NSString *serial_number;
@property (copy) NSString *created;
@property (assign) NSInteger reinserted;


@property (assign) NSInteger offer_id;
@property (copy) NSString *title;
@property (copy) NSString *description;
@property (copy) NSString *coupon_terms;
@property (assign) NSInteger offer_category_id;
@property (assign) NSInteger offer_type_id;
@property (assign) NSInteger vote_count;    
@property (assign) NSInteger vote_plus;
@property (assign) NSInteger vote_minus;
@property (copy) NSString *name;
@property (assign) NSInteger company_id;
@property (assign) NSInteger vote_sum;
@property (assign) NSInteger is_spam;
@property (assign) NSInteger offer_state_id;


@end
