//
//  SettingsMapViewController.h
//  Coupons
//
//  Created by Chytas Constatninos on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsMapViewController : UIViewController
{
    NSString *parentSegue;
    
    IBOutlet UISegmentedControl *segmentedControl;
}

@property (nonatomic, copy) NSString *parentSegue;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)pageChanged:(id)sender;

@end
