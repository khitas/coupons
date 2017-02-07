//
//  LocationViewController.h
//  Coupons
//
//  Created by Chytas Constatninos on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "clsOffer.h"
#import "clsCompany.h"

@interface LocationViewController : UIViewController <MKMapViewDelegate> {

    clsOffer *offer;
    clsCompany *company;
    NSMutableArray *annotations;
    
    IBOutlet MKMapView *mapView;

    IBOutlet UISegmentedControl *segmentedControl;
}

@property (nonatomic, strong) clsOffer *offer;
@property (nonatomic, strong) clsCompany *company;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)refresh:(id)sender;
- (IBAction)gotoCurentPosition:(id)sender;
- (IBAction)gotoCoupon:(id)sender;
- (IBAction)modeChanged:(id)sender;

@end
