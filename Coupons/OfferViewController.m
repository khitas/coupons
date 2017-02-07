//
//  OfferViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OfferViewController.h"
#import "MapViewAnnotation.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "clsOffer.h"
#import "Connection.h"

@interface OfferViewController ()

@end

@implementation OfferViewController

@synthesize offer;

@synthesize lblTitle;
@synthesize lblDescription;
@synthesize lblOfferCategory;
@synthesize lblOfferType;
@synthesize lblTags;
@synthesize lblCouponCount;
@synthesize lblMaxPerStudent;
@synthesize lblVoteCount;
@synthesize lblVotePlus;
@synthesize lblVoteMinus;
@synthesize lblStudentVote;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self showData];

}

-(void)showData
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [lblTitle setText:[NSString stringWithFormat:@"%@\n\n\n", [offer title]]];
    [lblDescription setText:[NSString stringWithFormat:@"%@\n\n\n", [offer description]]];    
    [lblOfferCategory setText:[offer offer_category]];
    [lblOfferType setText:[offer offer_type]];
    [lblTags setText:[offer tags]];
    [lblCouponCount setText:[NSString stringWithFormat:@"%d από %d", [offer coupon_count], [offer total_quantity] ]];
    [lblMaxPerStudent setText:[NSString stringWithFormat:@"%d", [offer max_per_student]]];
    
    [lblVotePlus  setText:[NSString stringWithFormat:@"+%d", [offer vote_plus]]];
    [lblVotePlus setTextColor:[myAppDelegate colorGreen]];
    
    [lblVoteMinus  setText:[NSString stringWithFormat:@"-%d", [offer vote_minus]]];
    [lblVoteMinus setTextColor:[myAppDelegate colorRed]];
    
    [lblVoteCount setText:[NSString stringWithFormat:@"(%d)", [offer vote_count]]];
    
    
    if ([[offer student_vote_type] isKindOfClass:[NSNull class]])
    {
        [lblStudentVote  setText:@""];
        [lblStudentVote setTextColor:[myAppDelegate colorNone]];
    }
    else if ([[NSString stringWithFormat:@"%@", [offer student_vote_type]] isEqualToString:@"0"])
    {
        [lblStudentVote  setText:@"-1"];
        [lblStudentVote setTextColor:[myAppDelegate colorRed]];
    }
    else if ([[NSString stringWithFormat:@"%@", [offer student_vote_type]] isEqualToString:@"1"])
    {
        [lblStudentVote  setText:@"+1"];
        [lblStudentVote setTextColor:[myAppDelegate colorGreen]];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)Vote:(id)sender
{    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *dataURL = [[NSString alloc] init];
    
    switch ([(UIButton *)sender tag] )
    {
        case 1:
            dataURL = @"/vote/vote_up";
            break;
        case 2:
            dataURL = @"/vote/vote_down";
            break;
        case 3:
            dataURL = @"/vote/vote_cancel";
            break;
        default:
            break;
    }

    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *vote_result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:[NSString stringWithFormat:@"%@/%d", dataURL, [offer offer_id]] andMethod:@"GET"]];
            
            int vote_status_code = [[vote_result valueForKey:@"status_code"] intValue];
            
            switch (vote_status_code)
            {
                case 200:
                {

                    NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:[NSString stringWithFormat:@"/offer/%d", [offer offer_id]] andMethod:@"GET"]];
                    
                    int status_code = [[result valueForKey:@"status_code"] intValue];
                    
                    switch (status_code)
                    {
                        case 200:
                        {
                            NSDictionary *record;
                            NSDictionary *subrecord;
                            
                            record = [result valueForKey:@"offer"];
                            [offer setVote_count:[[record objectForKey:@"vote_count"] intValue]];
                            [offer setVote_plus:[[record objectForKey:@"vote_plus"] intValue]];
                            [offer setVote_minus:[[record objectForKey:@"vote_minus"] intValue]];
                            [offer setVote_sum:[[record objectForKey:@"vote_sum"] intValue]];
                            
                            subrecord = [record objectForKey:@"student_vote"];
                            [offer setStudent_vote_type:[subrecord objectForKey:@"vote_type"]];
                            
                            
                            [lblVotePlus  setText:[NSString stringWithFormat:@"+%d", [offer vote_plus]]];
                            [lblVoteMinus  setText:[NSString stringWithFormat:@"-%d", [offer vote_minus]]];
                            [lblVoteCount setText:[NSString stringWithFormat:@"(%d)", [offer vote_count]]];
                            
                            if ([[offer student_vote_type] isKindOfClass:[NSNull class]])
                            {
                                [lblStudentVote  setText:@""];
                                [lblStudentVote setTextColor:[myAppDelegate colorNone]];
                            }
                            else if ([[NSString stringWithFormat:@"%@", [offer student_vote_type]] isEqualToString:@"0"])
                            {
                                [lblStudentVote  setText:@"-1"];
                                [lblStudentVote setTextColor:[myAppDelegate colorRed]];
                            }
                            else if ([[NSString stringWithFormat:@"%@", [offer student_vote_type]] isEqualToString:@"1"])
                            {
                                [lblStudentVote  setText:@"+1"];
                                [lblStudentVote setTextColor:[myAppDelegate colorGreen]];
                            }

                        }break;
                            
                        case 100:
                        case 403:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                                            message:[result valueForKey:@"message"]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"ΟΚ"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            
                            
                        }break;
                            
                        default:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                                            message:[result valueForKey:@"message"]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"ΟΚ"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }break;
                    }
                
                }break;
                    
                default:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                                    message:[vote_result valueForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"ΟΚ"
                                                          otherButtonTitles:nil];
                    [alert show];
                }break;
                    
            }
        }break;
            
        case 100:
        case 403:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                            message:[login_result valueForKey:@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:@"ΟΚ"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                            message:[login_result valueForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"ΟΚ"
                                                  otherButtonTitles:nil];
            [alert show];
        }break;
    }
    
    if ([offer student_coupon_enable] != 1)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
