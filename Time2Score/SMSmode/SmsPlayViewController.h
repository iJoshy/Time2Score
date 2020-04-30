//
//  SmsPlayViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HelperClass.h"

@interface SmsPlayViewController : UIViewController <MFMessageComposeViewControllerDelegate>
{
    int selected;
    id selectedID;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollviewMain;

@property (nonatomic, strong) IBOutlet UITextField *txtview;
@property (nonatomic, strong) IBOutlet UIButton *btnview;

@end

