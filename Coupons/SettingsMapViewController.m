//
//  SettingsMapViewController.m
//  Coupons
//
//  Created by Chytas Constatninos on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsMapViewController.h"
#import "AppDelegate.h"
#import "clsSettings.h"
#import "Connection.h"

@interface SettingsMapViewController ()

@end

@implementation SettingsMapViewController

@synthesize parentSegue;
@synthesize segmentedControl;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    segmentedControl.selectedSegmentIndex = [[myAppDelegate Settings] mapRadius];
    
/*
 NSIndexPath *indexPath;
    
/    if ([parentSegue isEqualToString:@"PushTypesOrderBy"]) 
        indexPath = [NSIndexPath indexPathForRow:[[myAppDelegate Settings] TypesOrderBy] inSection:0];
    else if ([parentSegue isEqualToString:@"PushCategoriesOrderBy"]) 
        indexPath = [NSIndexPath indexPathForRow:[[myAppDelegate Settings] CategoriesOrderBy] inSection:0];
    
    [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)pageChanged:(id)sender 
{
    [(UISegmentedControl*) sender setEnabled:YES forSegmentAtIndex:[(UISegmentedControl*) sender selectedSegmentIndex]];
    
    NSInteger radious;
    
    switch ([(UISegmentedControl*) sender selectedSegmentIndex])
    {
        case 0:
            radious = 1;
            break;
        case 1:
            radious = 5;
            break;
        case 2:
            radious = 10;
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
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn setRadius:radious]];
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
            
            switch (status_code)
            {
                case 200:
                {
                    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    [[myAppDelegate Settings] setMapRadius:[(UISegmentedControl*) sender selectedSegmentIndex] ];
                    
                    [[myAppDelegate Settings] Save];

                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ρυθμίσεις"
                                                                    message:[result valueForKey:@"message"]
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
}
@end
