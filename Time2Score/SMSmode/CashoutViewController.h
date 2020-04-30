//
//  CashoutViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CustomIOSAlertView.h"
#import "HelperClass.h"

@interface CashoutViewController : UIViewController <CustomIOSAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITextField *txtview;
@property (nonatomic, strong) IBOutlet UIButton *btnview;

@property (nonatomic, strong) NSString *screenType;
@property (nonatomic, strong) NSString *dialogMessage;
@property (nonatomic, strong) IBOutlet UILabel *lblphone;
@property (nonatomic, strong) IBOutlet UILabel *lblbalance;
@property (nonatomic, strong) IBOutlet UILabel *lblmsg;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) IBOutlet UIView *balanceview;

@property (strong, nonatomic) CustomIOSAlertView *alertView;
@property (nonatomic, strong) IBOutlet UITextField *dropdown;
@property (strong, nonatomic) UITableView *tableListView;
@property(nonatomic, strong) NSArray *gateways;

@end

