//
//  MyVotesTableViewController.m
//  Coupons
//
//  Created by Chytas Constantinos on 7/30/12.
//
//

#import "MyVotesTableViewController.h"
#import "AppDelegate.h"
#import "Connection.h"
#import "clsVote.h"
#import "clsSettings.h"
#import "MainOfferViewController.h"

@interface MyVotesTableViewController ()

@end

@implementation MyVotesTableViewController

@synthesize arrayVotes;
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
    
    arrayVotes = [[NSMutableArray alloc] init];
    
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
    
    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayVotes count]]];
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
    [arrayVotes removeAllObjects];
    
    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:@"/votes" andMethod:@"GET"]];
            
            int status_code = [[result valueForKey:@"status_code"] intValue];
            
            switch (status_code)
            {
                case 200:
                {
                    for (NSDictionary *record in [result valueForKey:@"votes"])
                    {
                        clsVote *vote = [[clsVote alloc] init];
                    
                        [vote setVote:[[record objectForKey:@"vote"] intValue]];

                        NSDictionary *subrecord = [record objectForKey:@"offer"];
                        [vote setOffer_id:[[subrecord objectForKey:@"id"] intValue]];
                        [vote setTitle:[subrecord objectForKey:@"title"]];
                        [vote setVote_count:[[subrecord objectForKey:@"vote_count"] intValue]];
                        [vote setVote_plus:[[subrecord objectForKey:@"vote_plus"] intValue]];
                        [vote setVote_minus:[[subrecord objectForKey:@"vote_minus"] intValue]];
                        [vote setVote_sum:[[subrecord objectForKey:@"vote_sum"] intValue]];
                        [vote setOffer_type_id:[[subrecord objectForKey:@"offer_type_id"] intValue]];
                        
                        [arrayVotes addObject:vote];
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
    
    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [arrayVotes count]]];
    
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    clsVote *vote = (clsVote *) [arrayVotes objectAtIndex:[indexPath row]];

    Connection *conn = [[Connection alloc] init];
    
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn voteOffer:@"/vote/vote_cancel" andOfferID:[vote offer_id]]];
              
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
    return [arrayVotes count];
}

- (NSString *)tableView:(UITableView *)tableView1 titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Διαγραφή";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    clsVote *vote = (clsVote *) [arrayVotes objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier;
    
    switch ([vote offer_type_id]) {
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    UILabel *cellLabel = (UILabel *)[cell textLabel];
    [cellLabel setText:[vote title]];
    
    UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
       
    [cellDetail setText:[NSString stringWithFormat:@"Η ψήφος μου : %@, +%d  -%d  (%d)", ([vote vote] == 1 ? @"+1" : @"-1"), [vote vote_plus], [vote vote_minus], [vote vote_count]]];

    if ([vote vote] == 1)
    {
        [cellLabel setTextColor:[myAppDelegate colorNone]];
        [cellDetail setTextColor:[myAppDelegate colorGreen]];
    }
    else
    {
        [cellLabel setTextColor:[myAppDelegate colorNone]];
        [cellDetail setTextColor:[myAppDelegate colorRed]];
    }
    
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
    if (([[segue identifier] isEqualToString:@"MyVotePushHappyHour"]) ||
        ([[segue identifier] isEqualToString:@"MyVotePushLimited"]) ||
        ([[segue identifier] isEqualToString:@"MyVotePushCoupon"]))
    {
        MainOfferViewController *viewController = [segue destinationViewController];
        
        clsVote *vote = (clsVote *) [arrayVotes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        [viewController setParentID:[vote offer_id]];
        [viewController setParentSegue:[segue identifier]];
        [viewController setParentName:[[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] textLabel] text]];
    }
}

@end