//
//  SmshomeViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HelperClass.h"

@interface SmshomeViewController : UIViewController <MFMessageComposeViewControllerDelegate> 

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@end

