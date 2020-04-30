//
//  TermsNconditionsViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface TermsNconditionsViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;

@property (nonatomic, copy) NSString * appTitle;
@property (nonatomic, copy) NSString * appAboutPageName;

@end
