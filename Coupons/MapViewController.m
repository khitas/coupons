//
//  MapViewController.m
//  Coupons
//
//  Created by Chytas Constantinos on 8/2/12.
//
//

#import "MapViewController.h"
#import "MyAnnotation.h"
#import "Connection.h"
#import "clsSettings.h"
#import "AppDelegate.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;
@synthesize segmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayCompanies = [[NSMutableArray alloc] init];
    arrayOffers = [[NSMutableArray alloc] init];
    annotations = [[NSMutableArray alloc] init];
    coordinatesIDs = [[NSMutableArray alloc] init];
    
    mapView.delegate=self;
    annotations = [[NSMutableArray alloc] init];

    [mapView setShowsUserLocation:YES];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    [mapView.userLocation setTitle:@"Η θέση μου"];

    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [mapView removeAnnotations:annotations];
    [annotations removeAllObjects];
   
	[self refresh:nil];
}


- (IBAction)refresh:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
}

-(void) loadData
{
    [mapView removeAnnotations:annotations];
    [annotations removeAllObjects];

    [arrayOffers removeAllObjects];
    [arrayCompanies removeAllObjects];
    
    [coordinatesIDs removeAllObjects];

    Connection *conn = [[Connection alloc] init];
    
    //Check Login
    NSDictionary *login_result = [[NSDictionary alloc] initWithDictionary:[conn autoLogin]];
    
    int login_status_code = [[login_result valueForKey:@"status_code"] intValue];
    
    switch (login_status_code)
    {
        case 200:
        {
            AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSInteger radious;
            
            switch ([[myAppDelegate Settings] mapRadius])
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
            
            //Set Radious
            NSDictionary *radious_result = [[NSDictionary alloc] initWithDictionary:[conn setRadius:radious]];
            
            int radious_status_code = [[radious_result valueForKey:@"status_code"] intValue];
            
            switch (radious_status_code)
            {
                case 200:
                {
                    //Set Coordinates
                    NSDictionary *coordinates_result = [[NSDictionary alloc] initWithDictionary:[conn setCoordinates:mapView.userLocation.location.coordinate.latitude andLongitude:mapView.userLocation.location.coordinate.longitude]];
                    
                    int coordinates_status_code = [[coordinates_result valueForKey:@"status_code"] intValue];
                    
                    switch (coordinates_status_code)
                    {
                        case 200:
                        {
                            
                            NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[conn loadListIndex:[NSString stringWithFormat:@"/offers/orderby:distance"] andMethod:@"GET"]];
                            
                            int status_code = [[result valueForKey:@"status_code"] intValue];
                            
                            switch (status_code)
                            {
                                case 200:
                                {
                                    if ( ! [[result valueForKey:@"companies"] isKindOfClass:[NSNull class]])
                                    {
                                        for (NSDictionary *record in [result valueForKey:@"companies"])
                                        {
                                            clsCompany *company = [[clsCompany alloc] init];
                                            
                                            [company setCompany_id:[[record objectForKey:@"id"] intValue]];
                                            [company setName:[record objectForKey:@"name"]];
                                            [company setAddress:[record objectForKey:@"address"]];
                                            [company setLatitude:[record objectForKey:@"latitude"]];
                                            [company setLongitude:[record objectForKey:@"longitude"]];
                                            
                                            [arrayCompanies addObject:company];
                                        }
                                        
                                        for (NSDictionary *record in [result valueForKey:@"offers"])
                                        {
                                            clsOffer *offer = [[clsOffer alloc] init ];
                                            
                                            [offer setOffer_id:[[record objectForKey:@"id"] intValue]];
                                            [offer setTitle:[record objectForKey:@"title"]];
                                            [offer setCompany_id:[[record objectForKey:@"company_id"] intValue]];
                                            
                                            for (clsCompany *company in arrayCompanies)
                                            {
                                                if ([company company_id] == [offer company_id])
                                                {
                                                    [offer setName:[company name]];
                                                    [offer setAddress:[company address]];
                                                    [offer setLatitude:[company latitude]];
                                                    [offer setLongitude:[company longitude]];
                                                }
                                            }
                                            
                                            [arrayOffers addObject:offer];
                                        }
                                    }                                    
                                    
                                    for (clsOffer *offer in arrayOffers)
                                    {
                                        while ( [coordinatesIDs containsObject:[NSString stringWithFormat:@"%@|%@", [offer latitude], [offer longitude]]])
                                        {
                                            double lat_val = (arc4random() % 10) * 0.000010;
                                            double lon_val = (arc4random() % 10) * 0.000010;
                                            
                                            double latitude = [[offer latitude] doubleValue] + ( ( arc4random() % 1 ) == 1 ? lat_val : -lat_val);
                                            double longitude = [[offer longitude] doubleValue] + ( ( arc4random() % 1 ) == 1 ? lon_val : -lon_val);;
                                            
                                            [offer setLatitude:[NSString stringWithFormat:@"%g", latitude]];
                                            [offer setLongitude:[NSString stringWithFormat:@"%g", longitude]];
                                        }
                                        
                                        NSLog(@"%@, %@", [offer latitude], [offer longitude]);
                                        
                                        
                                        CLLocationCoordinate2D coordinates;
                                        coordinates.latitude = [[offer latitude] doubleValue];
                                        coordinates.longitude = [[offer longitude] doubleValue];
                                        
                                        MyAnnotation *annotation=[[MyAnnotation alloc] init];
                                        annotation.title = [offer title];
                                        annotation.subtitle = [offer address];
                                        annotation.coordinate = coordinates;
                                        
                                        [mapView addAnnotation:annotation];
                                        
                                        [annotations addObject:annotation];
                                        
                                        [coordinatesIDs addObject:[NSString stringWithFormat:@"%@|%@", [offer latitude], [offer longitude]]];
                                    }
                                    
                                    NSLog(@"%d",[annotations count]);
                                    //[self gotoLocation];//to catch perticular area on screen
                                    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
                                    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
                                    
                                    // Walk the list of overlays and annotations and create a MKMapRect that
                                    // bounds all of them and store it into flyTo.
                                    MKMapRect flyTo = MKMapRectNull;
                                    for (id <MKAnnotation> annotation in annotations) {
                                        NSLog(@"fly to on");
                                        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                                        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                                        if (MKMapRectIsNull(flyTo)) {
                                            flyTo = pointRect;
                                        } else {
                                            flyTo = MKMapRectUnion(flyTo, pointRect);
                                            //NSLog(@"else-%@",annotationPoint.x);
                                        }
                                    }
                                    
                                    
                                    // Position the map so that all overlays and annotations are visible on screen.
                                    mapView.visibleMapRect = flyTo;
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
                            
                        default:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                                            message:[coordinates_result valueForKey:@"message"]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"ΟΚ"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }break;
                    }
                }break;
                    
                default:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Σφάλμα"
                                                                    message:[radious_result valueForKey:@"message"]
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

    [[[[self tabBarController] selectedViewController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", [coordinatesIDs count]]];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
	//NSLog(@"welcome into the map view annotation");
	
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	// try to dequeue an existing pin view first
	static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
	MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc]
                                    initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
	pinView.animatesDrop=YES;
	pinView.canShowCallout=YES;
	pinView.pinColor=MKPinAnnotationColorRed;
	
	
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
	[pinView setRightCalloutAccessoryView:rightButton];
	
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [leftButton setTitle:annotation.title forState:UIControlStateNormal];
    [pinView setLeftCalloutAccessoryView:leftButton];	
	
	return pinView;
}

- (void)mapView:(MKMapView *)mV annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        
        NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%g,%g&daddr=%g,%g",
                               mapView.userLocation.location.coordinate.latitude,
                               mapView.userLocation.location.coordinate.longitude,
                               [[view annotation] coordinate].latitude,
                               [[view annotation] coordinate].longitude];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if([(UIButton*)control buttonType] == UIButtonTypeInfoLight)
    {
        for(clsOffer *offer in arrayOffers)
        {
            NSString *current = [NSString stringWithFormat:@"%g|%g", [[view annotation] coordinate].latitude, [[view annotation] coordinate].longitude];
            NSString *company = [NSString stringWithFormat:@"%@|%@", [offer latitude], [offer longitude]];
            
            if ([current isEqualToString:company])
            {
                NSLog(@"%@, %@", current, company);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Πληροφορίες"
                                                                message:[offer name]
                                                               delegate:nil
                                                      cancelButtonTitle:@"ΟΚ"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }
}


- (IBAction)gotoCurentPosition:(id)sender
{
    [mapView setCenterCoordinate:[[mapView userLocation] coordinate] animated:YES];
}

- (IBAction)modeChanged:(id)sender
{
    switch ([(UISegmentedControl*) sender selectedSegmentIndex]) {
        case 0:
            [mapView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [mapView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [mapView setMapType:MKMapTypeHybrid];
            break;
        case UISegmentedControlNoSegment:
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
