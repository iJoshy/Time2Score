//
//  SignupViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HelperClass.h"

@interface SignupViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) IBOutlet UITextField *fname;
@property (nonatomic, strong) IBOutlet UITextField *lname;
@property (nonatomic, strong) IBOutlet UITextField *phoneno;
@property (nonatomic, strong) IBOutlet UITextField *pass;
@property (nonatomic, strong) IBOutlet UITextField *email;
    
@property (nonatomic, strong) NSDictionary *jsonResponse;
    
@end

