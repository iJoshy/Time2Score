//
//  RechargeViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HelperClass.h"

@interface RechargeViewController : UIViewController <MFMessageComposeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITextField *txtview;
@property (nonatomic, strong) IBOutlet UIButton *btnview;

@property (nonatomic, strong) NSString *screenType;
@property (nonatomic, strong) NSString *dialogMessage;
@property (nonatomic, strong) IBOutlet UILabel *lblphone;
@property (nonatomic, strong) IBOutlet UILabel *lblbalance;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSDictionary *jsonResponse2;
@property (nonatomic, strong) IBOutlet UIView *balanceview;

@end

