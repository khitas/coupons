//
//  ProfileTableViewController.m
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "AppDelegate.h"
#import "clsSettings.h"
#import "Connection.h"


@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

@synthesize myCoupons;
@synthesize myVotes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
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
    
    [self loadData];
    
    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:NULL];
}   

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - Table view data source


-(void) loadData
{
    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:@"/offers/statistics" andMethod:@"GET"]];
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
            
            switch (status_code)
            {
                case 200:
                {
                    NSDictionary *record = [result valueForKey:@"my_stats"];
                    
                    myCoupons = [record objectForKey:@"coupon_count"];
                    myVotes = [record objectForKey:@"vote_count"];

                    NSIndexPath *indexPath;
                    UITableViewCell *cell1;
                    UILabel *cellDetail1;
                    UITableViewCell *cell2;
                    UILabel *cellDetail2;
                    
                    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    cell1 = [[self tableView] cellForRowAtIndexPath:indexPath];
                    cellDetail1 = (UILabel *)[cell1 detailTextLabel];
                    [cellDetail1 setText:[NSString stringWithFormat:@"%@", myCoupons]];
                    
                    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    cell2 = [[self tableView] cellForRowAtIndexPath:indexPath];
                    cellDetail2 = (UILabel *)[cell2 detailTextLabel];
                    [cellDetail2 setText:[NSString stringWithFormat:@"%@", myVotes]];

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

- (void) alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title compare:@"Σφάλμα"] == NSOrderedSame)
    {
        if (buttonIndex == 0) //#define CANCEL 0 //#define OK 1
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}


-(IBAction) logout
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (void)refresh {

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSIndexPath *indexPath;
    UITableViewCell *cell1;
    UILabel *cellDetail1;
    UITableViewCell *cell2;
    UILabel *cellDetail2;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell1 = [[self tableView] cellForRowAtIndexPath:indexPath];
    cellDetail1 = (UILabel *)[cell1 detailTextLabel];
    [cellDetail1 setText:@"0"];
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    cell2 = [[self tableView] cellForRowAtIndexPath:indexPath];
    cellDetail2 = (UILabel *)[cell2 detailTextLabel];
    [cellDetail2 setText:@"0"];
    
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.2];
}

- (void)refreshData {
    
    [self loadData];

    [self stopLoading];    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    static NSString *CellIdentifier;
 
    if ([indexPath section] == 0)
    {
        CellIdentifier = @"CellMyCoupons";
    }
    else if ([indexPath section] == 1)
    {
        CellIdentifier = @"CellMyVotes";
    }
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([CellIdentifier isEqualToString:@"CellMyCoupons"])
    {
        // Get the cell label using it's tag and set it
        UILabel *cellLabel = (UILabel *)[cell textLabel];
        [cellLabel setText:[[myAppDelegate ProfileValues] objectAtIndex:0]];
        
        UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
        [cellDetail setText:[NSString stringWithFormat:@"%d", myCoupons]];        
    }
    else if ([CellIdentifier isEqualToString:@"CellMyVotes"])
    {
        // Get the cell label using it's tag and set it
        UILabel *cellLabel = (UILabel *)[cell textLabel];
        [cellLabel setText:[[myAppDelegate ProfileValues] objectAtIndex:1]];
        
        UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
        [cellDetail setText:[NSString stringWithFormat:@"%d", myVotes]];        
    }
    return cell;
}
*/

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
    
 /*   if ([[segue identifier] isEqualToString:@"ShowMyCoupons"]) {
        
        MyCouponsTableViewController *viewController = [segue destinationViewController];
        
        //clsType *type = (clsType *) [arrayTypes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        //[viewController setParentID:[type type_id]];
       // [viewController setParentSegue:@"ShowSelectedType"];
       // [viewController setParentName:[[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] textLabel] text]];

         
    }
  */
}

@end
