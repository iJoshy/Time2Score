//
//  RechargeViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

@synthesize scrollview, txtview, btnview;
@synthesize jsonResponse, lblphone, balanceview, screenType;
@synthesize lblbalance, dialogMessage, jsonResponse2;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    UITapGestureRecognizer *twTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    twTapGesture.cancelsTouchesInView = NO;
    [self.balanceview.superview addGestureRecognizer:twTapGesture];
    
    [super viewDidLoad];
    
}


-(IBAction)homeBtnClicked:(id)sender
{
    NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^([0-9]+)?$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    if (numberOfMatches == 0)
        return NO;
    
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 15;
    
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


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 320.0)];
    [self.scrollview setBounces:FALSE];
    
    txtview.layer.sublayerTransform = CATransform3DMakeTranslation(20.0f, 0.0f, 0.0f);
    
    screenType = [[NSUserDefaults standardUserDefaults] stringForKey:@"SCREENTYPE"];
    
    if ([screenType isEqualToString:@"DATA"])
    {
        lblphone.text = [NSString stringWithFormat:@"No: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"]];
        [self getBalance];
    }
    else if ([screenType isEqualToString:@"SMS"])
    {
        UIButton *balanceView = (UIButton*)[self.view   viewWithTag:300];
        [balanceView removeFromSuperview];
    }
    
}


-(void)getBalance
{
    lblbalance.text = [NSString stringWithFormat:@"₦ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"BALANCE"]];
}


-(IBAction)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    
    if (txtview.text.length == 0)
    {
        [self showSelfDismissingAlertViewWithMessage:@"This field is required"];
    }
    else
    {
        
        if ([screenType isEqualToString:@"DATA"])
        {
            [self callService];
        }
        else if ([screenType isEqualToString:@"SMS"])
        {            
            NSString *file = [NSString stringWithFormat:@"LOAD %@",txtview.text];
            [self showSMS:file];
        }
        
    }
    
}


-(void)callService
{
    
    NSString *voucher = txtview.text;
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    if (voucher.length == 15)
    {
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([voucher rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            [SVProgressHUD showWithStatus:@"Please wait ..."];
            jsonResponse  = nil;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                           {
                               WebServiceCall *ws = [[WebServiceCall alloc] init];
                               
                               NSDictionary *response = [ws recharge:token :voucher];
                               
                               [self setJsonResponse:response];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   //[SVProgressHUD dismiss];
                                   [self processInitData];
                               });
                           });
        }
        else
        {
            [self showSelfDismissingAlertViewWithMessage:@"Kindly type in a valid mobile number"];
        }
        
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:@"Kindly type in an 15 digit number"];
    }
    
    
}


-(void)processInitData
{
    
    NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    NSString *status = [dataContent objectForKey:@"status"];
    
    NSLog(@"message ::: %@",message);
    NSLog(@"success ::: %@",success);
    NSLog(@"status ::: %@",status);
    
    dialogMessage = message;
    success = [NSString stringWithFormat:@"%@",success];
    status = [NSString stringWithFormat:@"%@",status];
    
    if ([success isEqualToString:@"1"] && [status isEqualToString:@"3"])
    {
        [self walletBalance];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
    
    NSString *status_code = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"status_code"]];
    if ([status_code isEqualToString:@"500"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil userInfo:nil];
    
}



-(void)walletBalance
{
    
    jsonResponse2  = nil;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws balance:token];
                       
                       [self setJsonResponse2:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processWalletBalance];
                       });
                   });
}


-(void)processWalletBalance
{
    //NSLog(@" balance : %@",[self jsonResponse3]);
    
    NSDictionary * dataContent2 = [self jsonResponse2];
    NSString *success = [dataContent2 objectForKey:@"success"];
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        NSString *newBalance = [dataContent2 objectForKey:@"newBal"];
        [[NSUserDefaults standardUserDefaults] setObject:newBalance forKey:@"BALANCE"];
        
        [self performSegueWithIdentifier: @"RechargeAlertSegue" sender:self];
        [self getBalance];
        
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"RechargeAlertSegue"])
    {
        // Get reference to the destination view controller
        AlertDialogViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setFromWhere:@"RECHARGE"];
        [vc setAlerttitle:@"Recharge"];
        [vc setMessage:dialogMessage];
    }
}


- (void)showSMS:(NSString*)file
{
    
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"20120"];
    //NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:file];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}



- (void)showSelfDismissingAlertViewWithMessage:(NSString *)message
{
    
    
    CGSize scrSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize textSize = [self getSizeForText:message withFont:[UIFont fontWithName:@"Helvetica" size:15] maxSize:CGSizeMake(280, 200)];
    
    CGRect loadingFrame = CGRectMake(scrSize.width/2 - textSize.width/2 - 10, scrSize.height/2 - textSize.height/2 - (0), textSize.width + 20, textSize.height + 15);
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


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
