//
//  SettingsTableViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"
#import "clsSettings.h"
#import "SettingsOrderByTableViewController.h"
#import "SettingsMapViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

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

-(void)viewDidAppear:(BOOL)animated
{  
    NSIndexPath *indexPath;
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel setText:[[myAppDelegate SortValues] objectAtIndex:[[myAppDelegate Settings] typesOrderBy]]];
 
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel setText:[[myAppDelegate SortValues] objectAtIndex:[[myAppDelegate Settings] categoriesOrderBy]]];

    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel setText:[[myAppDelegate MapRadiusValues] objectAtIndex:[[myAppDelegate Settings] mapRadius]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;

    if (([indexPath row] == 0) && ([indexPath section] == 0))
    {
        CellIdentifier = @"";
    }
    else if (([indexPath row] == 0) && ([indexPath section] == 1))
    {
        CellIdentifier = @"";
    }
    else {
        CellIdentifier = @"Cell";
    }

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }


    if (([indexPath row] == 0) && ([indexPath section] == 0))
    {
        // Get the cell label using it's tag and set it
        UILabel *cellLabel = (UILabel *)[cell textLabel];
        [cellLabel setText:@"aaaa"];
        
        UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
        [cellDetail setText:@"asd"];
    }
    else if (([indexPath row] == 0) && ([indexPath section] == 1))
    {
        // Get the cell label using it's tag and set it
        UILabel *cellLabel = (UILabel *)[cell textLabel];
        [cellLabel setText:@"asd"];
        
        UILabel *cellDetail = (UILabel *)[cell detailTextLabel];
        [cellDetail setText:@"asd"];
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
    if ([[segue identifier] isEqualToString:@"PushTypesOrderBy"]) {
        
        SettingsOrderByTableViewController *viewController = [segue destinationViewController];
        
        [viewController setParentSegue:@"PushTypesOrderBy"];
        
    }
    else if ([[segue identifier] isEqualToString:@"PushCategoriesOrderBy"]) {
        
        SettingsOrderByTableViewController *viewController = [segue destinationViewController];

        [viewController setParentSegue:@"PushCategoriesOrderBy"];
    }
    else if ([[segue identifier] isEqualToString:@"PushMapRadiusΜα"]) {
        
        SettingsMapViewController *viewController = [segue destinationViewController];
        
        [viewController setParentSegue:@"PushMapRadius"];
    }}

@end
