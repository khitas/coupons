#import <UIKit/UIKit.h>

@interface clsVote : NSObject
{
    NSInteger offer_id;
    NSString *title;
    NSInteger vote_count;
    NSInteger vote_plus;
    NSInteger vote_minus;
    NSInteger vote_sum;    
    NSInteger vote;
    NSInteger offer_type_id;
}

@property (assign) NSInteger offer_id;
@property (copy) NSString *title;
@property (assign) NSInteger vote_count;
@property (assign) NSInteger vote_plus;
@property (assign) NSInteger vote_minus;
@property (assign) NSInteger vote_sum;
@property (assign) NSInteger vote;
@property (assign) NSInteger offer_type_id;
@end