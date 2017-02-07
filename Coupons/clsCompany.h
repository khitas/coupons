//
//  clsCompany.h
//  Coupons
//
//  Created by Kwstas Xytas on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsCompany : NSObject{
  
    NSInteger company_id;
    NSString *name;
    NSString *address;
    NSString *postalcode;
    NSString *phone;
    NSString *fax;
    NSString *service_type;
    NSString *afm;
    NSString *latitude;
    NSString *longitude;
    NSInteger is_enabled;
    NSInteger user_id;
    NSInteger municipality_id;
    NSInteger image_count;
    NSString *created;
    NSInteger modified;
}

@property (assign) NSInteger company_id;
@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSString *postalcode;
@property (copy) NSString *phone;
@property (copy) NSString *fax;
@property (copy) NSString *service_type;
@property (copy) NSString *afm;
@property (copy) NSString *latitude;
@property (copy) NSString *longitude;
@property (assign) NSInteger is_enabled;
@property (assign) NSInteger user_id;
@property (assign) NSInteger municipality_id;
@property (assign) NSInteger image_count;
@property (copy) NSString *created;
@property (assign) NSInteger modified;

@end
