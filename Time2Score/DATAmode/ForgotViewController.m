//
//  ForgotViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "ForgotViewController.h"

@interface ForgotViewController ()

@end

@implementation ForgotViewController

@synthesize scrollview, phonetxt, jsonResponse;
@synthesize resetBtn, signupBtn, dialogMessage;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 520.0)];
    [self.scrollview setBounces:FALSE];
    
}


-(IBAction)restClicked:(id)sender
{
    //NSLog(@"rest password");
    
    NSString *phoneS = phonetxt.text;
    
    if (phoneS.length == 11)
    {
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([phoneS rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            [SVProgressHUD showWithStatus:@"Please wait ..."];
            jsonResponse  = nil;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                           {
                               WebServiceCall *ws = [[WebServiceCall alloc] init];
                               
                               NSDictionary *response = [ws passwordreset:phoneS];
                               
                               [self setJsonResponse:response];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [SVProgressHUD dismiss];
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
        [self showSelfDismissingAlertViewWithMessage:@"Kindly type in an 11 digit number"];
    }
    
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
    
    return YES;
    
}



-(void)processInitData
{
    
    //NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    
    dialogMessage = message;
    //NSLog(@"message ::: %@",message);
    //NSLog(@"success ::: %@",success);
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier: @"ResetAlertSegue" sender:self];
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ResetAlertSegue"])
    {
        // Get reference to the destination view controller
        AlertDialogViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setFromWhere:@"FORGOT"];
        [vc setAlerttitle:@"Password Reset"];
        [vc setMessage:dialogMessage];
    }
}


-(IBAction)signupClicked:(id)sender
{
    //NSLog(@"signupClicked");
    [self dismissViewControllerAnimated:YES completion:nil];
    
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


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
