//
//  clsSettings.h
//  Coupons
//
//  Created by Kwstas Xytas on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsSettings : NSObject
{
    NSInteger typesOrderBy;
    NSInteger categoriesOrderBy;
    NSInteger mapRadius;
    NSString *userName;
    NSString *passWord;
    NSInteger rememberMe;
}

@property (assign) NSInteger typesOrderBy;
@property (assign) NSInteger categoriesOrderBy;
@property (assign) NSInteger mapRadius;
@property (copy) NSString *userName;
@property (copy) NSString *passWord;
@property (assign) NSInteger rememberMe;

-(void) Load;
-(void) Save;

@end
