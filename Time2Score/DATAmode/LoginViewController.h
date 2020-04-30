//
//  LoginViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) IBOutlet UIButton *forgotBtn;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) IBOutlet UIButton *smsBtn;
    
@property (nonatomic, strong) IBOutlet UITextField *phoneno;
@property (nonatomic, strong) IBOutlet UITextField *pass;

@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSDictionary *jsonResponse2;
    
@end

