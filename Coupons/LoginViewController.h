//
//  ViewController.h
//  Coupons
//
//  Created by Kwstas Xytas on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextView *textview;
    IBOutlet UISwitch *remember;
    
}

@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextView *textview;
@property (nonatomic, strong) IBOutlet UISwitch *remember;

-(void) login;
-(IBAction) refresh:(id)sender;

-(IBAction) makeKeyBoardGoAway;

-(IBAction) ShowCookie:(id)sender;
-(IBAction) testCookie:(id)sender;
-(IBAction) fakelogin:(id)sender;
-(IBAction) deleteCookie;

@end
