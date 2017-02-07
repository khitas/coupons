//
//  MyCouponsTableViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCouponsTableViewController.h"
#import "AppDelegate.h"
#import "Connection.h"
#import "clsCoupon.h"
#import "clsSettings.h"
#import "MainOfferViewController.h"

@interface MyCouponsTableViewController ()

@end

@implementation MyCouponsTableViewController

@synthesize arrayCoupons;

/*
 - (id)initWithStyle:(UITableViewStyle)style
 {
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayCoupons = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    
    //Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayCoupons count]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) loadData
{
    [arrayCoupons removeAllObjects];

    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:@"/coupons" andMethod:@"GET"]];
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
            
            switch (status_code)
            {
                case 200:
                {
                    for (NSDictionary *record in [result valueForKey:@"coupons"]){
                        
                        NSDictionary *record_offer = [record objectForKey:@"offer"];
                        NSDictionary *record_coupon = [record objectForKey:@"coupon"];
                        
                        clsCoupon *coupon = [[clsCoupon alloc] init];
                        
                        [coupon setCoupon_id:[[record_coupon objectForKey:@"id"] intValue]];
                        [coupon setSerial_number:[record_coupon objectForKey:@"serial_number"]];
                        [coupon setCreated:[record_coupon objectForKey:@"created"]];
                        [coupon setReinserted:[[record_coupon objectForKey:@"reinserted"] intValue]];
                        
                        [coupon setOffer_id:[[record_offer objectForKey:@"id"] intValue]];
                        [coupon setTitle:[record_offer objectForKey:@"title"]];
                        [coupon setDescription:[record_offer objectForKey:@"description"]];
                        [coupon setCoupon_terms:[record_offer objectForKey:@"coupon_terms"]];
                        [coupon setOffer_category_id:[[record_offer objectForKey:@"offer_category_id"] intValue]];
                        [coupon setOffer_type_id:[[record_offer objectForKey:@"offer_type_id"] intValue]];
                        [coupon setVote_count:[[record_offer objectForKey:@"vote_count"] intValue]];
                        [coupon setVote_plus:[[record_offer objectForKey:@"vote_plus"] intValue]];
                        [coupon setVote_minus:[[record_offer objectForKey:@"vote_minus"] intValue]];
                        [coupon setCompany_id:[[record_offer objectForKey:@"company_id"] intValue]];
                        [coupon setVote_sum:[[record_offer objectForKey:@"vote_sum"] intValue]];
                        [coupon setIs_spam:[[record_offer objectForKey:@"is_spam"] intValue]];
                        [coupon setOffer_state_id:[[record_offer objectForKey:@"offer_state_id"] intValue]];
                        
                        [arrayCoupons addObject:coupon];
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
    
    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayCoupons count]]];
}

- (void) alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title compare:@"Σφάλμα"] == NSOrderedSame)
    {
        if (buttonIndex == 0) //#define CANCEL 0 //#define OK 1
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if ([actionSheet.title compare:@"Αποδέσμευση και επιστροφή κουπονιού"] == NSOrderedSame)
    {
        if (buttonIndex == 0) //#define CANCEL 0 //#define OK 1
        {
            Connection *conn = [[Connection alloc] init];
            
            NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
            
            int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
            
            switch (login_status_code)
            {
                case 200:
                {
                    clsCoupon *coupon = (clsCoupon *) [arrayCoupons objectAtIndex:RowIndexToDelete];

                    NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn releaseCoupon:[coupon coupon_id]]];
                    
                    int status_code = [[result valueForKey:@"status_code"] intValue];
                    
                    switch (status_code)
                    {
                        case 200:
                        {
                            [self refresh];
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
    }
}

#pragma mark - Table view data source

- (void)refresh {
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.2];
}

- (void)refreshData {
    
    [self loadData];
    [self.tableView reloadData];
    
    [self stopLoading];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayCoupons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    clsCoupon *coupon = (clsCoupon *) [arrayCoupons objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier;
 
    if ([coupon is_spam] == 1)
        CellIdentifier = @"CellSpam";
    else
    {
        switch ([coupon offer_type_id]) {
            case 1:
                CellIdentifier = @"CellHappyHour";
                break;
            case 2:
                CellIdentifier = @"CellCoupons";
                break;
            case 3:
                CellIdentifier = @"CellLimited";
                break;
            default:
                CellIdentifier = @"CellIdentifier";
                break;
        }
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
   /*
    UILabel *cellLabel = (UILabel *)[cell textLabel];
    if ([coupon reinserted] == 1)
        [cellLabel setText:[NSString stringWithFormat:@"[ΕΠΙΣΤΡΟΦΗ] %@", [coupon title]]];
    else if ([coupon is_spam] == 1)
        [cellLabel setText:[NSString stringWithFormat:@"[SPAM] %@", [coupon title]]];
    else if ([coupon offer_state_id] == 3)
        [cellLabel setText:[NSString stringWithFormat:@"[ΕΛΗΞΕ] %@", [coupon title]]];
    else
        [cellLabel setText:[coupon title]];

    
    UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
    [cellDetail setText:[coupon serial_number]];
   */
    
    UILabel *cellLabel = (UILabel *)[cell textLabel];
    [cellLabel setText:[coupon title]];

    UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
    
    if ([coupon reinserted] == 1)
        [cellDetail setText:[NSString stringWithFormat:@"[ΕΠΙΣΤΡΟΦΗ] %@", [coupon serial_number]]];
    else if ([coupon is_spam] == 1)
        [cellDetail setText:[NSString stringWithFormat:@"[SPAM] %@", [coupon serial_number]]];
    else if ([coupon offer_state_id] == 3)
        [cellDetail setText:[NSString stringWithFormat:@"[ΕΛΗΞΕ] %@", [coupon serial_number]]];
    else
        [cellDetail setText:[coupon serial_number]];

    
    
    
    
    if ([coupon is_spam] == 1)
    {
        [cellLabel setTextColor:[myAppDelegate colorRed]];
        [cellDetail setTextColor:[myAppDelegate colorRed]];
    }
    else if (([coupon reinserted] == 1) || ([coupon offer_state_id] == 3))
    {
        [cellLabel setTextColor:[UIColor lightGrayColor]];
        [cellDetail setTextColor:[UIColor lightGrayColor]];
    }
    else
    {
        [cellLabel setTextColor:[myAppDelegate colorNone]];
        [cellDetail setTextColor:[myAppDelegate colorNone]];        
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    clsCoupon *coupon = (clsCoupon *) [arrayCoupons objectAtIndex:indexPath.row];

    return ([coupon reinserted] == 0) && ([coupon offer_state_id] == 2);
}

- (NSString *)tableView:(UITableView *)tableView1 titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Επιστροφή";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RowIndexToDelete = [indexPath row];
    
   // clsCoupon *coupon = (clsCoupon *) [arrayCoupons objectAtIndex:indexPath.row];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Αποδέσμευση και επιστροφή κουπονιού"
                                                    message:@"Προσοχή: Αυτή η ενέργεια δεν μπορεί να αναιρεθεί."
                                                   delegate:self
                                          cancelButtonTitle:@"Εντάξει"
                                          otherButtonTitles:@"Άκυρο", nil];
    [alert show];
}

- (IBAction)openDelete:(id)sender
{
    if ([[(UIBarButtonItem*) sender title] isEqualToString:@"Αλλαγές"])
    {
        [[self tableView] setEditing:YES animated:YES];
        [(UIBarButtonItem*) sender setTitle:@"Εντάξει"];
    }
    else
    {
        [[self tableView] setEditing:NO animated:YES];
        [(UIBarButtonItem*) sender setTitle:@"Αλλαγές"];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (([[segue identifier] isEqualToString:@"MyCouponPushHappyHour"]) ||
        ([[segue identifier] isEqualToString:@"MyCouponPushLimited"]) ||
        ([[segue identifier] isEqualToString:@"MyCouponPushCoupon"]))
    {
        MainOfferViewController *viewController = [segue destinationViewController];
        
        clsCoupon *coupon = (clsCoupon *) [arrayCoupons objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        NSString *segueString = [[NSString alloc] init];
        
        if ([coupon reinserted] == 1)
        {
            if ([[segue identifier] isEqualToString:@"MyCouponPushHappyHour"])
                segueString = @"ShowHappyHour";
            if ([[segue identifier] isEqualToString:@"MyCouponPushLimited"])
                segueString = @"ShowLimited";
            if ([[segue identifier] isEqualToString:@"MyCouponPushCoupon"])
                segueString = @"ShowCoupon";
        }
        else
        {
            segueString = [segue identifier];
        }
        
        [viewController setCouponID:[coupon coupon_id]];
        [viewController setParentID:[coupon offer_id]];
        [viewController setParentSegue:segueString];
        [viewController setParentName:[[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] textLabel] text]];
    }
}

@end