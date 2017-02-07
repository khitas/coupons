//
//  OffersIndexTableViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OffersIndexTableViewController.h"
#import "AppDelegate.h"
#import "clsSettings.h"
#import "clsOffer.h"
#import "clsCompany.h"
#import "SBJson.h"
#import "MainOfferViewController.h"
#import "Connection.h"

@interface OffersIndexTableViewController ()

@end

@implementation OffersIndexTableViewController

@synthesize parentID;
@synthesize parentName;
@synthesize parentSegue;
@synthesize searchString;
@synthesize segmentedControl;
@synthesize searchBar;

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

    arrayOffers = [[NSMutableArray alloc] init];

    //[[self navigationItem] setPrompt:parentName];
    [self setTitle:parentName];
    
    searchString = [[NSString alloc] initWithFormat:@""];
    
    pageID = 1;
        
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

    [self refresh];
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

- (void)refresh
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
}

-(void) loadData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [arrayOffers removeAllObjects];
    
    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSString *orderBy;
            NSString *dataURL = [[NSString alloc] init];
            
            if ( ![searchString isEqualToString:@""])
            {
                NSString *escapedUrlString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                dataURL = [NSString stringWithFormat:@"/search/contains:%@", escapedUrlString];
                //dataURL = [NSString stringWithFormat:@"/search/contains:%@", searchString];
                //dataURL = [NSString stringWithFormat:@"/search/contains:%%CE%%B5%%CE%%BC%%CF%%80%%CF%%8C%%CF%%81%%CE%%B9%%CE%%BF"];
                
                if ([parentSegue isEqualToString:@"ShowSelectedType"])
                    orderBy = [[myAppDelegate SortKeys] objectAtIndex:[[myAppDelegate Settings] typesOrderBy]];
                else if ([parentSegue isEqualToString:@"ShowSelectedCategory"])
                    orderBy = [[myAppDelegate SortKeys] objectAtIndex:[[myAppDelegate Settings] categoriesOrderBy]];
            }
            else if ([parentSegue isEqualToString:@"ShowSelectedType"])
            {
                switch (parentID) {
                    case 0:
                        dataURL = @"/offers/index";
                        break;
                    case 1:
                        dataURL = @"/offers/happyhour";
                        break;
                    case 2:
                        dataURL = @"/offers/coupons";
                        break;
                    case 3:
                        dataURL = @"/offers/limited";
                        break;
                    default:
                        dataURL = @"/offers/index";
                        break;
                }
                
                orderBy = [[myAppDelegate SortKeys] objectAtIndex:[[myAppDelegate Settings] typesOrderBy]];
            }
            else if ([parentSegue isEqualToString:@"ShowSelectedCategory"])
            {
                switch (parentID)
                {
                    case 0:
                        dataURL = @"/offers/index";
                        break;
                    default:
                        dataURL = [NSString stringWithFormat:@"/offers/category/%d", parentID];
                        break;
                }
                
                orderBy = [[myAppDelegate SortKeys] objectAtIndex:[[myAppDelegate Settings] categoriesOrderBy]];
            }
            
            Connection *conn = [[Connection alloc] init];

            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:[NSString stringWithFormat:@"%@/orderby:%@/page:%d",
                                                                                                 dataURL,
                                                                                                 orderBy,
                                                                                                 pageID]  andMethod:@"GET"]];
            
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
            
            
            switch (status_code)
            {
                case 200:
                {
                    if (![[result valueForKey:@"offers"]  isKindOfClass:[NSNull class]])
                    {
                        for (NSDictionary *record in [result valueForKey:@"offers"]){
                            
                            clsOffer *offer = [[clsOffer alloc] init ];
                            
                            [offer setOffer_id:[[record objectForKey:@"id"] intValue]];
                            [offer setTitle:[record objectForKey:@"title"]];
                            [offer setCreated:[record objectForKey:@"created"]];
                            [offer setOffer_type:[[record objectForKey:@"offer_type"] capitalizedString]];
                            [offer setOffer_category:[record objectForKey:@"offer_category"]];
                            
                            [arrayOffers addObject:offer];
                            
                        }
                    }

                    NSDictionary *pagination = [result valueForKey:@"pagination"];
                    
                    [self setTitle:[NSString stringWithFormat:@"%d/%d %@", [[pagination objectForKey:@"page"] intValue], [[pagination objectForKey:@"pageCount"] intValue], parentName]];
                    
                    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [[pagination objectForKey:@"count"] intValue]]];
                    
                    pageID = [[pagination objectForKey:@"page"] intValue];
                    
                    if ([[pagination objectForKey:@"prevPage"] intValue] > 0)
                        [segmentedControl setEnabled:YES forSegmentAtIndex:0];
                    else
                        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
                    
                    if ([[pagination objectForKey:@"page"] intValue] < [[pagination objectForKey:@"pageCount"] intValue])
                        [segmentedControl setEnabled:YES forSegmentAtIndex:1];
                    else
                        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
                    
                    [segmentedControl setSelectedSegmentIndex:-1];
                }break;
                    
                default:
                {
                    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", 0]];
                    
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO ];
    
    [self.tableView reloadData];
    
    [self stopLoading];
}

#pragma mark -
#pragma mark Search Bar


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)sender
{
    [searchBar resignFirstResponder];

    searchString = [searchBar text];
    [self refresh];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sender
{
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    searchString = [searchBar text];
    [self refresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [arrayOffers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    clsOffer *offer = (clsOffer *) [arrayOffers objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier;
    
    if ([[offer offer_type] isEqualToString:@"Happy Hour"])
        CellIdentifier = @"CellHappyHour";
    else if ([[offer offer_type] isEqualToString:@"Coupons"])
        CellIdentifier = @"CellCoupons";
    else if ([[offer offer_type] isEqualToString:@"Limited"])
        CellIdentifier = @"CellLimited";
    else 
        CellIdentifier = @"CellIdentifier";
 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    UILabel *cellLabel = (UILabel *)[cell textLabel];
    [cellLabel setText:[(clsOffer *) [arrayOffers objectAtIndex:indexPath.row] title]];
    
    NSArray *date_array = [[(clsOffer *) [arrayOffers objectAtIndex:indexPath.row] created] componentsSeparatedByString:@" "];
    
    NSString *typeName;
    if ([parentSegue isEqualToString:@"ShowSelectedType"]) 
        typeName = [(clsOffer *) [arrayOffers objectAtIndex:indexPath.row] offer_category];
    else if ([parentSegue isEqualToString:@"ShowSelectedCategory"]) 
        typeName = [(clsOffer *) [arrayOffers objectAtIndex:indexPath.row] offer_type];
    
    
    UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
    [cellDetail setText:[NSString stringWithFormat:@"%@, %@", typeName, [date_array objectAtIndex:0]]];

    // get the cell imageview using it's tag and set it
    //UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
    //[cellImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", indexPath.row]]];
    
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
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



- (IBAction)pageChanged:(id)sender 
{
    [(UISegmentedControl*) sender setEnabled:YES forSegmentAtIndex:[(UISegmentedControl*) sender selectedSegmentIndex]];

    switch ([(UISegmentedControl*) sender selectedSegmentIndex]) {
        case 0:
			pageID--;
            break;
        case 1:
			pageID++;
            break;
        case UISegmentedControlNoSegment:
            break;
        default:
            break;
    }

    [self refresh];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (([[segue identifier] isEqualToString:@"ShowHappyHour"]) ||
        ([[segue identifier] isEqualToString:@"ShowLimited"]) ||
        ([[segue identifier] isEqualToString:@"ShowCoupon"]))
    {
        MainOfferViewController *viewController = [segue destinationViewController];
        
        clsOffer *offer = (clsOffer *) [arrayOffers objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        [viewController setParentID:[offer offer_id]];
        [viewController setParentSegue:[segue identifier]];
        [viewController setParentName:[[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] textLabel] text]];
    }
}


@end
