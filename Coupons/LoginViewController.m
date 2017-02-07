//
//  ViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "clsSettings.h"
#import "Connection.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username;
@synthesize password;
@synthesize textview;
@synthesize remember;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[myAppDelegate Settings] rememberMe] == 1)
    {
        [username setText:[[myAppDelegate Settings] userName]];
        [password setText:[[myAppDelegate Settings] passWord]];
        
        if ([myAppDelegate firstRun])
        {
            [myAppDelegate setFirstRun:NO];
            [self refresh:nil];
        }
    }
    else
    {
        [username setText:@""];
        [password setText:@""];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)refresh:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self performSelector:@selector(login) withObject:nil afterDelay:0.2];
}

-(void) login{
    
    [username resignFirstResponder];
	[password resignFirstResponder];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if ([[username text] isEqualToString:@""]){
		
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σύνδεση" 
                                                        message:@"Παρακαλώ συμπληρώστε το Όνομα Χρήστη"  
                                                       delegate:nil 
                                              cancelButtonTitle:@"ΟΚ" 
                                              otherButtonTitles:nil];
		[alert show];
	}
    else if ([[password text] isEqualToString:@""]){
		
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σύνδεση" 
                                                        message:@"Παρακαλώ συμπληρώστε τον Κωδικό Πρόσβασης"  
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		[alert show];
	}	
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
        Connection *conn = [[Connection alloc] init];
        
        NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn login:[username text] andPassWord:[password text]] ];
       
        int status_code = [[result valueForKey:@"status_code"] intValue];
        
        switch (status_code)
        {
            case 200:
            {
                [[myAppDelegate Settings] setUserName:[username text]];
                [[myAppDelegate Settings] setPassWord:[password text]];
                [[myAppDelegate Settings] setRememberMe:([remember isOn] ? 1 : 0 )];
                
                [[myAppDelegate Settings] Save];
                
                [[myAppDelegate window] addSubview:[[myAppDelegate tabBarController] view]];
                [[myAppDelegate window] makeKeyAndVisible];
                
                [self performSegueWithIdentifier:@"PushMainController" sender:nil];

            }break;
                
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σύνδεση"
                                                                message:[result valueForKey:@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"ΟΚ"
                                                      otherButtonTitles:nil];
                [alert show];

            }break;
        }
        
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(IBAction) makeKeyBoardGoAway{
    
	[username resignFirstResponder];
	[password resignFirstResponder];
	
}

-(IBAction) fakelogin:(id)sender
{
    Connection *conn = [[Connection alloc] init];
    
    NSLog (@"%@", [[NSDictionary alloc] initWithDictionary:[conn login:[username text] andPassWord:[password text]] ]);
}


-(IBAction)ShowCookie:(id)sender
{
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:@"http://coupons.edu.teiath.gr"]];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject])
    {
        NSLog(@"%@\n%@\n%@", [cookie value], [cookie expiresDate],cookie );
    }

}

-(IBAction)testCookie:(id)sender
{
    NSHTTPURLResponse *response;
    NSData *responseData;
    
    NSMutableURLRequest *request;
    NSData *requestData;
    
    NSError *error;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/coordinates/lat:%@/lng:%@",
                                                                             [myAppDelegate DBServerLink],
                                                                             @"38.0031063",
                                                                             @"23.6736546"]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    requestData = [[NSString stringWithFormat:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:@"http://coupons.edu.teiath.gr/api"]];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    NSLog(@"Request:\n%@", [[NSString alloc] initWithData:requestData  encoding: NSUTF8StringEncoding]);
    NSLog(@"RequestHeaders: \n%@\n", [request allHTTPHeaderFields]);
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Respose:\n%@", [[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding]);
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                        message:[NSString stringWithFormat:@"%d : %@", [error code], [error localizedDescription]]
                                                       delegate:nil
                                              cancelButtonTitle:@"ΟΚ"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSDictionary *jsonDictionary = [parser objectWithString:[[NSString alloc] initWithData:responseData  encoding: NSUTF8StringEncoding] error:nil];
        
        int status_code = [[jsonDictionary valueForKey:@"status_code"] intValue];
        
        if (status_code == 200 )
        {
            
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ok"
                                                            message:[jsonDictionary valueForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"ΟΚ"
                                                  otherButtonTitles:nil];
            [alert show];
           
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                            message:[jsonDictionary valueForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"ΟΚ"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }

}



-(IBAction)deleteCookie
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:@"http://coupons.edu.teiath.gr/api"]];
    NSLog(@"old cookies!: %@",cookies);
    NSHTTPCookie *cookie;
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    NSLog(@"new cookies!: %@",cookies);

}


//  When we have logged in successfully, we need to pass the managed object context to our table view (via the navigation controller)
//  so we get a reference to the navigation controller first, then get the last controller in the nav stack, and pass the MOC to it
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 //   UITabBarController *tabBarController = (UITabBarController *)[segue destinationViewController];
    
    //TypesIndexTableViewController *viewController =  (TypesIndexTableViewController *)[[tabBarController viewControllers] objectAtIndex:0];

    //UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
    //TypesIndexTableViewController *piclist = (TypesIndexTableViewController *)[[navController viewControllers] lastObject];
    //piclist.managedObjectContext = managedObjectContext;
}

@end
