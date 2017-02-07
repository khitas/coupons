//
//  MapViewController.h
//  Coupons
//
//  Created by Chytas Constantinos on 8/2/12.
//
//

#import <UIKit/UIKit.h>
#import "clsOffer.h"
#import "clsCompany.h"
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> 
{
    NSMutableArray *arrayOffers;
    NSMutableArray *arrayCompanies;
    NSMutableArray *annotations;
    NSMutableArray *coordinatesIDs;

    BOOL canContinue;
    
    IBOutlet MKMapView *mapView;

    IBOutlet UISegmentedControl *segmentedControl;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)refresh:(id)sender;
- (IBAction)gotoCurentPosition:(id)sender;
- (IBAction)modeChanged:(id)sender;


@end
