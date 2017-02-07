//
//  Connection.h
//  Coupons
//
//  Created by Kwstas Xytas on 27/7/12.
//
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject

-(NSDictionary *) login:(NSString *)userName andPassWord:(NSString *)passWord;
-(NSDictionary *) autoLogin;

-(NSDictionary *) loadListIndex:(NSString *)URL andMethod:(NSString *)Method;

-(NSDictionary *) getCoupon:(NSInteger)couponID;
-(NSDictionary *) releaseCoupon:(NSInteger)couponID;
-(NSDictionary *) setRadius:(NSInteger)radious;
-(NSDictionary *) setCoordinates:(double)latitude andLongitude:(double)longitude;

-(NSDictionary *) voteOffer:(NSString *)URL andOfferID:(NSInteger) offerID;
@end
