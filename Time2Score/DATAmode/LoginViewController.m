//
//  LoginViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize scrollview, jsonResponse, jsonResponse2;
@synthesize forgotBtn, playBtn;
@synthesize registerBtn, smsBtn;
@synthesize phoneno, pass;

- (void)viewDidLoad
{
    
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewDidAppear:(BOOL)animated
{
    NSString *loggedin = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOGGEDIN"];
    if ([loggedin isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier: @"DatahomeSegue" sender:self];
    }
    else
    {
        
        NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"];
        if (!([phone isEqualToString:@""] || phone == NULL))
        {
            phone = [NSString stringWithFormat:@"0%@",[phone substringFromIndex:3]];
            phoneno.text = phone;
        }
        
        self.navigationController.navigationBarHidden = YES;
        
        [self setUpView];
    }
    
    [super viewDidAppear:animated];
    
}


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 550.0)];
    [self.scrollview setBounces:FALSE];
    
    pass.secureTextEntry = TRUE;
    
}


-(IBAction)forgotClicked:(id)sender
{
    //NSLog(@"forgotClicked");
    
    [self performSegueWithIdentifier: @"ForgotSegue" sender:self];
    
}


-(IBAction)registerClicked:(id)sender
{
    //NSLog(@"registerClicked");
    
    [self performSegueWithIdentifier: @"RegisterSegue" sender:self];
    
}


-(IBAction)smsClicked:(id)sender
{
    //NSLog(@"smsClicked");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshContent" object:@"SMS"];
    
    [self performSegueWithIdentifier: @"SmsalertSegue" sender:self];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"SmsalertSegue"])
    {
        // Get reference to the destination view controller
        AlertDialogViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setFromWhere:@"LOGIN"];
        [vc setAlerttitle:@"PLAY via SMS"];
        [vc setMessage:@"You have chosen to play via sms, charges will apply for each sms sent. You can exit this mode by selecting \"Exit SMS Mode\" from the menu"];
    }
}


-(IBAction)playClicked:(id)sender
{
    //NSLog(@"playClicked");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshContent" object:@"DATA"];
    
    //[self performSegueWithIdentifier: @"DatahomeSegue" sender:self];
    
    NSString *phonenoS = phoneno.text;
    NSString *passS = pass.text;
    
    if (phonenoS.length == 11 || phonenoS.length == 13)
    {
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([phonenoS rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            [SVProgressHUD showWithStatus:@"authenticating ..."];
            jsonResponse  = nil;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                           {
                               WebServiceCall *ws = [[WebServiceCall alloc] init];
                               
                               NSDictionary *response = [ws login:phonenoS :passS];
                               
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
        [self showSelfDismissingAlertViewWithMessage:@"Kindly type in an 11 digit number"];
    }
    
     
}


-(void)processInitData
{
    
    //NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    
    //NSLog(@"message ::: %@",message);
    //NSLog(@"success ::: %@",success);
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        
        NSString *phone = [dataContent objectForKey:@"phone"];
        NSString *firstname =  [dataContent objectForKey:@"firstname"];
        NSString *lastname =  [dataContent objectForKey:@"lastname"];
        NSString *email = [dataContent objectForKey:@"email"];
        
        /*
        NSLog(@"phone ::: %@",phone);
        NSLog(@"firstname ::: %@",firstname);
        NSLog(@"lastname ::: %@",lastname);
        NSLog(@"email ::: %@",email);
        */
        
        [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"TOKEN"];
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"PHONE"];
        
        if (!firstname) [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"FIRSTNAME"];
        if (!lastname) [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"LASTNAME"];
        if (!email) [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
        
        [self getBalance:message];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
}


-(void)getBalance:(NSString *)token
{
    
    jsonResponse2  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws balance:token];
                       
                       [self setJsonResponse2:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processBalance];
                       });
                   });
}


-(void)processBalance
{
    //NSLog(@" balance : %@",[self jsonResponse2]);
    
    NSDictionary * dataContent = [self jsonResponse2];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    
    /*
    NSLog(@"message ::: %@",message);
    NSLog(@"success ::: %@",success);
    */
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        
        NSString *newBalance = [dataContent objectForKey:@"newBal"];
        //NSLog(@"balance ::: %@",newBalance);
        [[NSUserDefaults standardUserDefaults] setObject:newBalance forKey:@"BALANCE"];
        
        NSString *winningsBal = [dataContent objectForKey:@"winningsBal"];
        //NSLog(@"winningsBal ::: %@",winningsBal);
        [[NSUserDefaults standardUserDefaults] setObject:winningsBal forKey:@"WINNINGSBAL"];
        
        NSString *gamingBal = [dataContent objectForKey:@"gamingBal"];
        //NSLog(@"gamingBal ::: %@",gamingBal);
        [[NSUserDefaults standardUserDefaults] setObject:gamingBal forKey:@"GAMINGBAL"];
        
        NSString *promoBal = [dataContent objectForKey:@"promoBal"];
        //NSLog(@"promoBal ::: %@",promoBal);
        [[NSUserDefaults standardUserDefaults] setObject:promoBal forKey:@"PROMOBAL"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LOGGEDIN"];
        [self performSegueWithIdentifier: @"DatahomeSegue" sender:self];
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
}


- (void)showSelfDismissingAlertViewWithMessage:(NSString *)message
{
    
    
    CGSize scrSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize textSize = [self getSizeForText:message withFont:[UIFont fontWithName:@"Helvetica" size:15] maxSize:CGSizeMake(280, 200)];
    
    CGRect loadingFrame = CGRectMake(scrSize.width/2 - textSize.width/2 - 10, scrSize.height/2 - textSize.height/2 - (60), textSize.width + 20, textSize.height + 15);
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




- (IBAction)unwindToLogin:(UIStoryboardSegue *)unwindSegue
{
    //NSLog(@"::: login from register :::");
}


@end
