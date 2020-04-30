//
//  RegisterViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HelperClass.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    BOOL checkboxSelected;
    IBOutlet UIButton *checkboxButton;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITextField *phoneno;
@property (nonatomic, strong) NSDictionary *jsonResponse;

- (IBAction)checkboxButton:(id)sender;

@end

