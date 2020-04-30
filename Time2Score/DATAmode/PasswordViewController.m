//
//  PasswordViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

@synthesize scrollview, txtview, txt2view, btnview;
@synthesize jsonResponse, lblphone, balanceview;
@synthesize lblbalance, txt3view;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    UITapGestureRecognizer *twTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    twTapGesture.cancelsTouchesInView = NO;
    [self.balanceview.superview addGestureRecognizer:twTapGesture];
    
    [super viewDidLoad];
    
}


- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(self.balanceview.frame, point))
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HISTORY" object:nil userInfo:nil];
        }
    }
}


-(IBAction)homeBtnClicked:(id)sender
{
    NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 320.0)];
    [self.scrollview setBounces:FALSE];
    
    txtview.layer.sublayerTransform = CATransform3DMakeTranslation(12.0f, 0.0f, 0.0f);
    txt2view.layer.sublayerTransform = CATransform3DMakeTranslation(12.0f, 0.0f, 0.0f);
    txt3view.layer.sublayerTransform = CATransform3DMakeTranslation(12.0f, 0.0f, 0.0f);
    
    txtview.secureTextEntry = TRUE;
    txt2view.secureTextEntry = TRUE;
    txt3view.secureTextEntry = TRUE;
    
    lblphone.text = [NSString stringWithFormat:@"No: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"]];
    lblbalance.text = [NSString stringWithFormat:@"₦ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"BALANCE"]];
    
}


-(IBAction)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    
    if (txtview.text.length == 0  || txt2view.text.length == 0 || txt3view.text.length == 0)
    {
        [self showSelfDismissingAlertViewWithMessage:@"This field is required"];
    }
    else
    {
        if ( [txt2view.text isEqualToString:txt3view.text])
        {
            [self callService];
        }
        else
        {
            [self showSelfDismissingAlertViewWithMessage:@"Passwords did not match"];
        }
    }
    
}


-(void)callService
{
    
    NSString *currentP = txtview.text;
    NSString *newP = txt2view.text;
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    jsonResponse  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
       {
           WebServiceCall *ws = [[WebServiceCall alloc] init];
           
           NSDictionary *response = [ws password:token :currentP :newP];
           
           [self setJsonResponse:response];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               [SVProgressHUD dismiss];
               [self processInitData];
           });
       });

    
}


-(void)processInitData
{
    
    //NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    
    NSLog(@"message ::: %@",message);
    NSLog(@"success ::: %@",success);
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        txtview.text = @"";
        txt2view.text = @"";
        txt3view.text = @"";
        
        [self showSelfDismissingAlertViewWithMessage:message];
        
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
    
    NSString *status_code = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"status_code"]];
    if ([status_code isEqualToString:@"500"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil userInfo:nil];
    
    
}


- (void)showSelfDismissingAlertViewWithMessage:(NSString *)message
{
    
    
    CGSize scrSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize textSize = [self getSizeForText:message withFont:[UIFont fontWithName:@"Helvetica" size:15] maxSize:CGSizeMake(280, 200)];
    
    CGRect loadingFrame = CGRectMake(scrSize.width/2 - textSize.width/2 - 10, scrSize.height/2 - textSize.height/2 - (30), textSize.width + 20, textSize.height + 15);
    UIView *viewMessage = [[UIView alloc] initWithFrame:loadingFrame];
    [viewMessage setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, textSize.width, textSize.height)];
    [loadingLabel setNumberOfLines:0];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [loadingLabel setText:message];
    [viewMessage addSubview:loadingLabel];
    
    [viewMessage.layer setCornerRadius:4.0f];
    [self.view addSubview:viewMessage];
    
    [self performSelector:@selector(removeSelfDismissingAlertView:)
               withObject:viewMessage
               afterDelay:4.0];
    
}


- (CGSize)getSizeForText:(NSString *)text withFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    CGSize sizeText = CGSizeZero;
    
    NSDictionary *fontDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect textRect = [text boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:fontDict
                                         context:nil];
    sizeText = textRect.size;
    
    return sizeText;
}


- (void)removeSelfDismissingAlertView:(UIView *)viewMessage {
    [UIView animateWithDuration:0.25f
                     animations:^ {
                         [viewMessage setAlpha:0.0f];
                     }
                     completion:^ (BOOL finished) {
                         [viewMessage removeFromSuperview];
                     }];
}


- (IBAction)backButtonPressed:(id)sender
{
    NSString *from = [[NSUserDefaults standardUserDefaults] stringForKey:@"FROM"];
    if( [from isEqualToString:@"HOME"] )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if( [from isEqualToString:@"MENU"] )
    {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
