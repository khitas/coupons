//
//  clsUser.h
//  Coupons
//
//  Created by Kwstas Xytas on 21/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsUser : NSObject {
    NSString *Username;
    NSString *Firstname;
    NSString *Lastname;    
}

@property (nonatomic, strong) NSString* Username;
@property (nonatomic, strong) NSString* Firstname;
@property (nonatomic, strong) NSString* Lastname;

@end
