//
//  PasswordViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface PasswordViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITextField *txtview;
@property (nonatomic, strong) IBOutlet UITextField *txt2view;
@property (nonatomic, strong) IBOutlet UITextField *txt3view;
@property (nonatomic, strong) IBOutlet UIButton *btnview;

@property (nonatomic, strong) IBOutlet UILabel *lblphone;
@property (nonatomic, strong) IBOutlet UILabel *lblbalance;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) IBOutlet UIView *balanceview;

@end

