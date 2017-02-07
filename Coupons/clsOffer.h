//
//  clsOffer.h
//  Coupons
//
//  Created by Kwstas Xytas on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsOffer : NSObject
{  
    NSInteger offer_id;
    NSString *title;
    NSString *description;
    NSString *started;
    NSString *ended;
    NSString *autostart;
    NSString *autoend;
    NSString *coupon_terms;
    NSInteger total_quantity;
    NSInteger coupon_count;
    NSInteger max_per_student;
    NSString *tags;
    NSInteger company_id;
    NSInteger image_count;
    NSString *is_spam;
    NSInteger vote_count;    
    NSInteger vote_plus;
    NSInteger vote_minus;
    NSString *created;
    NSString *modified;
    NSInteger vote_sum;
    NSString *offer_category;
    NSString *offer_type;
    NSString *offer_state;
    NSInteger offer_state_id;
    NSString *student_vote_type;
    NSInteger student_coupon_enable;
    
    NSString *name;
    NSString *address;
    NSString *latitude;
    NSString *longitude;

}

@property (assign) NSInteger offer_id;
@property (copy) NSString *title;
@property (copy) NSString *description;
@property (copy) NSString *started;
@property (copy) NSString *ended;
@property (copy) NSString *autostart;
@property (copy) NSString *autoend;
@property (copy) NSString *coupon_terms;
@property (assign) NSInteger total_quantity;
@property (assign) NSInteger coupon_count;
@property (assign) NSInteger max_per_student;
@property (copy) NSString *tags;
@property (assign) NSInteger company_id;
@property (assign) NSInteger image_count;
@property (copy) NSString *is_spam;
@property (assign) NSInteger vote_count;    
@property (assign) NSInteger vote_plus;
@property (assign) NSInteger vote_minus;
@property (copy) NSString *created;
@property (copy) NSString *modified;
@property (assign) NSInteger vote_sum;
@property (copy) NSString *offer_category;
@property (copy) NSString *offer_type;
@property (copy) NSString *offer_state;
@property (assign) NSInteger offer_state_id;
@property (copy) NSString *student_vote_type;
@property (assign) NSInteger student_coupon_enable;

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSString *latitude;
@property (copy) NSString *longitude;

@end
