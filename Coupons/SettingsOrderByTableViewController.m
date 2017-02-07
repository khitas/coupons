//
//  SettingsTypesOrderByTableViewController.m
//  Coupons
//
//  Created by Kwstas Xytas on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsOrderByTableViewController.h"
#import "AppDelegate.h"
#import "clsSettings.h"

@interface SettingsOrderByTableViewController ()

@end

@implementation SettingsOrderByTableViewController

@synthesize parentSegue;


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
    
    if ([parentSegue isEqualToString:@"PushTypesOrderBy"]) 
        [self setTitle:@"Τύποι"];
    else if ([parentSegue isEqualToString:@"PushCategoriesOrderBy"]) 
        [self setTitle:@"Κατηγορίες"];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSIndexPath *indexPath;
    
    if ([parentSegue isEqualToString:@"PushTypesOrderBy"]) 
        indexPath = [NSIndexPath indexPathForRow:[[myAppDelegate Settings] typesOrderBy] inSection:0];
    else if ([parentSegue isEqualToString:@"PushCategoriesOrderBy"]) 
        indexPath = [NSIndexPath indexPathForRow:[[myAppDelegate Settings] categoriesOrderBy] inSection:0];
    
    [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
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
    return 4;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
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
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSIndexPath *prevIndexPath;
    
    if ([parentSegue isEqualToString:@"PushTypesOrderBy"]) 
        prevIndexPath = [NSIndexPath indexPathForRow:[[myAppDelegate Settings] typesOrderBy] inSection:0];
    else if ([parentSegue isEqualToString:@"PushCategoriesOrderBy"]) 
        prevIndexPath = [NSIndexPath indexPathForRow:[[myAppDelegate Settings] categoriesOrderBy] inSection:0];

    
    [[self.tableView cellForRowAtIndexPath:prevIndexPath] setAccessoryType:UITableViewCellAccessoryNone];

    [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
  
    
    if ([parentSegue isEqualToString:@"PushTypesOrderBy"]) 
        [[myAppDelegate Settings] setTypesOrderBy:[indexPath row]];
    else if ([parentSegue isEqualToString:@"PushCategoriesOrderBy"]) 
        [[myAppDelegate Settings] setCategoriesOrderBy:[indexPath row]];
    
    
    [[myAppDelegate Settings] Save];
}

@end
