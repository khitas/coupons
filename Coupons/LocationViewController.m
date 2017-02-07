//
//  LocationViewController.m
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "MapViewAnnotation.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize offer;
@synthesize company;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    annotations = [[NSMutableArray alloc] init];

    mapView.delegate=self;

    [segmentedControl setSelectedSegmentIndex:0];

    [mapView setShowsUserLocation:YES];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    [mapView.userLocation setTitle:@"Η θέση μου"];
    
    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	[self refresh:nil];
}


- (IBAction)refresh:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
}


- (IBAction)gotoCurentPosition:(id)sender
{
    [mapView setCenterCoordinate:[[[mapView annotations] objectAtIndex:1] coordinate] animated:YES];
}

- (IBAction)gotoCoupon:(id)sender
{
    [mapView setCenterCoordinate:[[[mapView annotations] objectAtIndex:0] coordinate] animated:YES];
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

-(void) loadData
{
    [mapView removeAnnotations:annotations];
    [annotations removeAllObjects];
     
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [[offer latitude] doubleValue];
    coordinates.longitude = [[offer longitude] doubleValue];
    
	region.span=span;
	region.center=coordinates;
    
    MyAnnotation *annotation=[[MyAnnotation alloc] init];
    annotation.title = [offer title];
    annotation.subtitle = [offer address];
    annotation.coordinate = coordinates;
    
    [mapView addAnnotation:annotation];
    
    [annotations addObject:annotation];
        
    [mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];

    NSLog(@"%d",[annotations count]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if(annotation != mapView.userLocation)
    {
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }

        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.animatesDrop=TRUE;
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5, 5);
        annotationView.enabled = YES;
        
        // Create a UIButton object to add on the
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [leftButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setLeftCalloutAccessoryView:leftButton];
        
        return annotationView;
    }
    
    return nil; 
}

- (void)mapView:(MKMapView *)mV annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){

        NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%g,%g&daddr=%g,%g", 
                               mapView.userLocation.location.coordinate.latitude, 
                               mapView.userLocation.location.coordinate.longitude, 
                               [[company latitude] doubleValue], 
                               [[company longitude] doubleValue]];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];        
        
    } else if([(UIButton*)control buttonType] == UIButtonTypeInfoLight) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Πληροφορίες" 
                                                        message:[company name]  
                                                       delegate:nil 
                                              cancelButtonTitle:@"ΟΚ" 
                                              otherButtonTitles:nil];
        [alert show];
    }
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


@end
