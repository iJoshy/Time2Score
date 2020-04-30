//
//  ForgotViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "helperClass.h"

@interface ForgotViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) NSString *dialogMessage;
@property (nonatomic, strong) IBOutlet UITextField *phonetxt;
@property (nonatomic, strong) IBOutlet UIButton *resetBtn;
@property (nonatomic, strong) IBOutlet UIButton *signupBtn;

@property (nonatomic, strong) NSDictionary *jsonResponse;

@end

