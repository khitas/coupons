//
//  clsType.h
//  Coupons
//
//  Created by Kwstas Xytas on 12/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface clsType : NSObject
{
    NSInteger type_id;
    NSString *name;
    NSInteger offer_count;
}

@property (assign) NSInteger type_id;
@property (copy) NSString *name;
@property (assign) NSInteger offer_count;

@end
