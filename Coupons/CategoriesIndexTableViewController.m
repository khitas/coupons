//
//  CategoriesIndexTableViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesIndexTableViewController.h"
#import "OffersIndexTableViewController.h"
#import "clsType.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "Connection.h"

@interface CategoriesIndexTableViewController ()

@end

@implementation CategoriesIndexTableViewController

@synthesize arrayCategories;
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
    
    arrayCategories = [[NSMutableArray alloc] init];
    
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

    [self refresh];
    
    if ([arrayCategories count] == 0)
        [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayCategories count]]];
    else
        [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayCategories count]-1]];
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

- (void)refresh
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
}

-(void) loadData
{
    [arrayCategories removeAllObjects];
    
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
                    clsType *type = [[clsType alloc] init ];
                    
                    [type setType_id:0];
                    [type setName:@"Όλες οι κατηγορίες"];
                    [type setOffer_count:[[result valueForKey:@"total_offers"] intValue]];
                    
                    [arrayCategories addObject:type];
                    
                    
                    for (NSDictionary *category in [result valueForKey:@"categories"]){
                        
                        clsType *type = [[clsType alloc] init ];
                        
                        [type setType_id:[[category objectForKey:@"id"] intValue]];
                        [type setName:[category objectForKey:@"name"]];
                        [type setOffer_count:[[category objectForKey:@"offer_count"] intValue]];
                        
                        [arrayCategories addObject:type];
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
    
    if ([arrayCategories count] == 0)
        [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayCategories count]]];
    else
        [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayCategories count]-1]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO ];
    
    [self.tableView reloadData];
    
    [self stopLoading];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    clsType *type = (clsType *) [arrayCategories objectAtIndex:indexPath.row];
    
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // Get the cell label using it's tag and set it
    UILabel *cellLabel = (UILabel *)[cell textLabel];
    [cellLabel setText:[type name]];
    
    UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
    [cellDetail setText:[NSString stringWithFormat:@"%d", [type offer_count]]];
    
    // get the cell imageview using it's tag and set it
    //UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
    //[cellImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", indexPath.row]]];
    
    //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
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
    if ([[segue identifier] isEqualToString:@"ShowSelectedCategory"]) {
        
        OffersIndexTableViewController *viewController = [segue destinationViewController];
        
        [viewController setParentID:[[self.tableView indexPathForSelectedRow] row]];
        [viewController setParentSegue:@"ShowSelectedCategory"];
        [viewController setParentName:[[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] textLabel] text]];
    }
}



@end
