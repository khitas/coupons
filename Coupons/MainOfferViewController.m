//
//  MainOfferViewController.m
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import "MainOfferViewController.h"

#import "OfferViewController.h"
#import "CompanyViewController.h"
#import "TermsViewController.h"
#import "LocationViewController.h"
#import "CouponViewController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "clsOffer.h"
#import "Connection.h"

@interface MainOfferViewController ()

@end

@implementation MainOfferViewController

@synthesize couponID;
@synthesize parentID;
@synthesize parentName;
@synthesize parentSegue;

@synthesize coupon;
@synthesize offer;
@synthesize company;

@synthesize btnGetCoupon;

- (void)viewDidLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];

    coupon = [[clsCoupon alloc] init ];
    offer = [[clsOffer alloc] init ];
    company = [[clsCompany alloc] init ];

    [self loadData];
    
    [self setTitle:[offer title]];

    if (([parentSegue isEqualToString:@"MyCouponPushHappyHour"]) ||
        ([parentSegue isEqualToString:@"MyCouponPushLimited"]) ||
        ([parentSegue isEqualToString:@"MyCouponPushCoupon"]))
    {
        CouponViewController *viewCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMyCoupon"];
        [viewCoupon setCoupon:coupon];
        [self addChildViewController:viewCoupon];
    }

    
    if (([parentSegue isEqualToString:@"ShowHappyHour"]) ||
        ([parentSegue isEqualToString:@"MyCouponPushHappyHour"]) ||
        ([parentSegue isEqualToString:@"MyVotePushHappyHour"]))
    {
        OfferViewController *viewOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"viewHappyHour"];
        [viewOffer setOffer:offer];
        [self addChildViewController:viewOffer];
    }
    else if (([parentSegue isEqualToString:@"ShowLimited"]) ||
             ([parentSegue isEqualToString:@"MyCouponPushLimited"]) ||
             ([parentSegue isEqualToString:@"MyVotePushLimited"]))
    {
        OfferViewController *viewOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"viewLimited"];
        [viewOffer setOffer:offer];
        [self addChildViewController:viewOffer];
    }
    else if (([parentSegue isEqualToString:@"ShowCoupon"]) ||
             ([parentSegue isEqualToString:@"MyCouponPushCoupon"]) ||
             ([parentSegue isEqualToString:@"MyVotePushCoupon"]))
    {
        OfferViewController *viewOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCoupon"];
        [viewOffer setOffer:offer];
        [self addChildViewController:viewOffer];
    }
    
 
    CompanyViewController *viewCompany = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCompany"];
    [viewCompany setCompany:company];
    [self addChildViewController:viewCompany];

 
    
    TermsViewController *viewTerms = [self.storyboard instantiateViewControllerWithIdentifier:@"viewTerms"];
    [viewTerms setOffer:offer];
    [self addChildViewController:viewTerms];
    
 
    
    LocationViewController *viewMap = [self.storyboard instantiateViewControllerWithIdentifier:@"viewMap"];
    [viewMap setOffer:offer];
    [viewMap setCompany:company];
    [self addChildViewController:viewMap];
    
    
    [self.view addSubview:[self pageControl]];
    //self.pageControl.backgroundColor = [UIColor redColor];

}


-(void) loadData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];

    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:[NSString stringWithFormat:@"/offer/%d", parentID] andMethod:@"GET"]];
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
            
            switch (status_code)
            {
                case 200:
                {
                    NSDictionary *record;
                    NSDictionary *subrecord;

                    // if ([[offer student_vote_type] isKindOfClass:[NSNull class]])
                    record = [result valueForKey:@"offer"];
                    [offer setOffer_id:[[record objectForKey:@"id"] intValue]];
                    [offer setTitle:[record objectForKey:@"title"]];
                    [offer setDescription:[record objectForKey:@"description"]];
                    [offer setStarted:[record objectForKey:@"started"]];
                    [offer setEnded:[record objectForKey:@"ended"]];
                    [offer setAutostart:[record objectForKey:@"autostart"]];
                    [offer setAutoend:[record objectForKey:@"autoend"]];
                    
                    if (![[record objectForKey:@"coupon_terms"] isKindOfClass:[NSNull class]])
                        [offer setCoupon_terms:[record objectForKey:@"coupon_terms"]];

                    if (![[record objectForKey:@"total_quantity"] isKindOfClass:[NSNull class]])
                        [offer setTotal_quantity:[[record objectForKey:@"total_quantity"] intValue]];
                    if (![[record objectForKey:@"coupon_count"] isKindOfClass:[NSNull class]])
                        [offer setCoupon_count:[[record objectForKey:@"coupon_count"] intValue]];
                    if (![[record objectForKey:@"max_per_student"] isKindOfClass:[NSNull class]])
                        [offer setMax_per_student:[[record objectForKey:@"max_per_student"] intValue]];
                    [offer setTags:[record objectForKey:@"tags"]];
                    if (![[record objectForKey:@"company_id"] isKindOfClass:[NSNull class]])
                        [offer setCompany_id:[[record objectForKey:@"company_id"] intValue]];
                    if (![[record objectForKey:@"image_count"] isKindOfClass:[NSNull class]])
                        [offer setImage_count:[[record objectForKey:@"image_count"] intValue]];
                    [offer setIs_spam:[record objectForKey:@"is_spam"]];
                    if (![[record objectForKey:@"vote_count"] isKindOfClass:[NSNull class]])
                        [offer setVote_count:[[record objectForKey:@"vote_count"] intValue]];
                    if (![[record objectForKey:@"vote_plus"] isKindOfClass:[NSNull class]])
                        [offer setVote_plus:[[record objectForKey:@"vote_plus"] intValue]];
                    if (![[record objectForKey:@"vote_minus"] isKindOfClass:[NSNull class]])
                        [offer setVote_minus:[[record objectForKey:@"vote_minus"] intValue]];
                    [offer setCreated:[record objectForKey:@"created"]];
                    [offer setModified:[record objectForKey:@"modified"]];
                    if (![[record objectForKey:@"vote_sum"] isKindOfClass:[NSNull class]])
                        [offer setVote_sum:[[record objectForKey:@"vote_sum"] intValue]];
                    [offer setOffer_category:[record objectForKey:@"offer_category"]];
                    [offer setOffer_type:[[record objectForKey:@"offer_type"] capitalizedString]];
                    [offer setOffer_state:[record objectForKey:@"offer_state"]];
                    if (![[record objectForKey:@"offer_state_id"] isKindOfClass:[NSNull class]])
                        [offer setOffer_state_id:[[record objectForKey:@"offer_state_id"] intValue]];
                    
                    subrecord = [record objectForKey:@"student_vote"];
                    [offer setStudent_vote_type:[subrecord objectForKey:@"vote_type"]];
                    
                    subrecord = [record objectForKey:@"student_coupon"];
                    [offer setStudent_coupon_enable:[[subrecord objectForKey:@"enabled"]  intValue]];
                    
                    record = [result valueForKey:@"company"];
                    [company setCompany_id:[[record objectForKey:@"id"] intValue]];
                    [company setName:[record objectForKey:@"name"]];
                    [company setAddress:[record objectForKey:@"address"]];
                    [company setPostalcode:[record objectForKey:@"postalcode"]];
                    [company setPhone:[record objectForKey:@"phone"]];
                    [company setFax:[record objectForKey:@"fax"]];
                    [company setService_type:[record objectForKey:@"service_type"]];
                    [company setAfm:[record objectForKey:@"afm"]];
                    [company setLatitude:[record objectForKey:@"latitude"]];
                    [company setLongitude:[record objectForKey:@"longitude"]];
                    [company setIs_enabled:[[record objectForKey:@"is_enabled"] intValue]];
                    [company setUser_id:[[record objectForKey:@"user_id"] intValue]];
                    [company setMunicipality_id:[[record objectForKey:@"municipality_id"] intValue]];
                    [company setImage_count:[[record objectForKey:@"image_count"] intValue]];
                    [company setCreated:[record objectForKey:@"created"]];
                    [company setModified:[[record objectForKey:@"modified"] intValue]];
                    
                    [offer setLatitude:[record objectForKey:@"latitude"]];
                    [offer setLongitude:[record objectForKey:@"longitude"]];
                    [offer setName:[record objectForKey:@"name"]];
                    [offer setAddress:[record objectForKey:@"address"]];
                    
                    
                    if (([parentSegue isEqualToString:@"MyCouponPushHappyHour"]) ||
                        ([parentSegue isEqualToString:@"MyCouponPushLimited"]) ||
                        ([parentSegue isEqualToString:@"MyCouponPushCoupon"]))
                    {
                        
                        NSDictionary *coupon_result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:[NSString stringWithFormat:@"/coupon/%d", couponID] andMethod:@"GET"]];
                            
                        int coupon_status_code = [[coupon_result valueForKey:@"status_code"] intValue];
                            
                        switch (coupon_status_code)
                        {
                            case 200:
                            {
                                NSDictionary *coupon_record;
                                
                                coupon_record = [coupon_result valueForKey:@"coupon"];
                                [coupon setCoupon_id:[[coupon_record objectForKey:@"id"] intValue]];
                                [coupon setSerial_number:[coupon_record objectForKey:@"serial_number"]];
                                [coupon setCreated:[coupon_record objectForKey:@"created"]];
                                [coupon setReinserted:[[coupon_record objectForKey:@"reinserted"] intValue]];
                                
                                coupon_record = [coupon_result valueForKey:@"offer"];
                                [coupon setTitle:[coupon_record objectForKey:@"title"]];

                                coupon_record = [coupon_result valueForKey:@"company"];
                                [coupon setName:[coupon_record objectForKey:@"name"]];
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
                    }
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
    
    
    if ([[offer offer_state] isEqualToString:@"inactive"])
    {
        self.navigationItem.rightBarButtonItem = nil;        
    }
    else if ([offer student_coupon_enable] != 1)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)refresh
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self loadData];
    
    if (([parentSegue isEqualToString:@"MyCouponPushHappyHour"]) ||
        ([parentSegue isEqualToString:@"MyCouponPushLimited"]) ||
        ([parentSegue isEqualToString:@"MyCouponPushCoupon"]))
    {
        CouponViewController *viewCoupon = [[self childViewControllers] objectAtIndex:0];
        [viewCoupon setCoupon:coupon];
        [viewCoupon showData];
        
        OfferViewController *viewOffer = [[self childViewControllers] objectAtIndex:1];
        [viewOffer setOffer:offer];
        [viewOffer showData];
        
        CompanyViewController *viewCompany = [[self childViewControllers] objectAtIndex:2];
        [viewCompany setCompany:company];
        [viewCompany showData];
        
        TermsViewController *viewTerms = [[self childViewControllers] objectAtIndex:3];
        [viewTerms setOffer:offer];
        [viewTerms showData];
        
        LocationViewController *viewMap = [[self childViewControllers] objectAtIndex:4];
        [viewMap setOffer:offer];
        [viewMap setCompany:company];
        [viewMap refresh:nil];
    }
    else
    {
        OfferViewController *viewOffer = [[self childViewControllers] objectAtIndex:0];
        [viewOffer setOffer:offer];
        [viewOffer showData];
        
        CompanyViewController *viewCompany = [[self childViewControllers] objectAtIndex:1];
        [viewCompany setCompany:company];
        [viewCompany showData];
        
        TermsViewController *viewTerms = [[self childViewControllers] objectAtIndex:2];
        [viewTerms setOffer:offer];
        [viewTerms showData];
        
        LocationViewController *viewMap = [[self childViewControllers] objectAtIndex:3];
        [viewMap setOffer:offer];
        [viewMap setCompany:company];
        [viewMap refresh:nil];
    }
}

-(IBAction)getCoupon:(id)sender
{
    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn getCoupon:parentID ]];
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
         
            switch (status_code)
            {
                case 200:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Κουπόνι"
                                                                    message:[NSString stringWithFormat:@"%@\n%@",
                                                                             [result valueForKey:@"message"],
                                                                             [result valueForKey:@"serial_number"]]
                                                                   delegate:nil
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
    
    [self refresh];
}

@end
