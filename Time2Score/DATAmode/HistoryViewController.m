//
//  HistoryViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize scrollview, columnView1, columnView2, columnView3;
@synthesize jsonResponse, lblphone, balanceview, lblbalance;
@synthesize gaminglbl, winninglbl, promolbl, backview, jsonResponse2;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self walletBalances];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)homeBtnClicked:(id)sender
{
    NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)walletBalances
{
    [SVProgressHUD showWithStatus:@"loading ..."];
    jsonResponse2  = nil;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws balance:token];
                       
                       [self setJsonResponse2:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           //[SVProgressHUD dismiss];
                           [self processBalance];
                       });
                   });
}


-(void)processBalance
{
    //NSLog(@" balance : %@",[self jsonResponse2]);
    
    NSDictionary * dataContent2 = [self jsonResponse2];
    NSString *message = [dataContent2 objectForKey:@"message"];
    NSString *success = [dataContent2 objectForKey:@"success"];
    
    /*
     NSLog(@"message ::: %@",message);
     NSLog(@"success ::: %@",success);
     */
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        lblphone.text = [NSString stringWithFormat:@"No: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"]];
        lblbalance.text = [NSString stringWithFormat:@"₦ %@",[dataContent2 objectForKey:@"newBal"]];
        
        gaminglbl.text = [NSString stringWithFormat:@"Gaming: %@",[dataContent2 objectForKey:@"gamingBal"]];
        winninglbl.text = [NSString stringWithFormat:@"Winnings: %@",[dataContent2 objectForKey:@"winningsBal"]];
        promolbl.text = [NSString stringWithFormat:@"Promo: %@",[dataContent2 objectForKey:@"promoBal"]];
        
        [self callService];
        
    }
    else
    {
        [SVProgressHUD dismiss];
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
}


-(void)callService
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    jsonResponse  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
       {
           WebServiceCall *ws = [[WebServiceCall alloc] init];
           
           NSDictionary *response = [ws history:token];
           
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
    NSString *success = [dataContent objectForKey:@"success"];
    //NSLog(@"success ::: %@",success);
    
    
    success = [NSString stringWithFormat:@"%@",success];
    
    int scrollLength = 0;
    
    if ([success isEqualToString:@"1"])
    {
        NSArray *message = [dataContent objectForKey:@"message"];
        //NSLog(@"message array ::: %@",message);
        
        
        for(int i = 0; i < [message count]; i++)
        {
                
            NSDictionary *eachArray = [message objectAtIndex:i];
            
            NSDictionary *msgDateArray = [eachArray objectForKey:@"transDate"];
            NSString *dateS = [msgDateArray objectForKey:@"date"];
            NSString *date = [self formatDate:[dateS substringWithRange:NSMakeRange(0, 10)]];
            
            NSString *descrS = [eachArray objectForKey:@"transInfo"];
            NSString *creditS = [eachArray objectForKey:@"credit"];
            NSString *debitS = [eachArray objectForKey:@"debit"];
            
            /*
            NSLog(@"Date %d ::: %@\n",i,date);
            NSLog(@"descr %d ::: %@\n",i,descrS);
            NSLog(@"credit %d ::: %@\n",i,creditS);
            NSLog(@"debit %d ::: %@\n",i,debitS);
            NSLog(@"walletBal %d ::: %@\n",i,walletBalS);
            NSLog(@"winnings %d ::: %@\n",i,winningsS);
            NSLog(@"promo %d ::: %@\n",i,promoS);
            */
            
            UILabel *datelbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 195 + (i * 50), 60, 50)];
            [datelbl setTextColor:[UIColor whiteColor]];
            [datelbl setBackgroundColor:[UIColor clearColor]];
            [datelbl setFont:[UIFont fontWithName: @"Helvetica Neue" size: 9.0f]];
            [datelbl setText:date];
            [datelbl setTextAlignment:NSTextAlignmentCenter];
            datelbl.lineBreakMode = NSLineBreakByWordWrapping;
            datelbl.numberOfLines = 0;
            [datelbl sizeToFit];
            [scrollview addSubview:datelbl];
            
            columnView1.frame = CGRectMake(81, 166, 1, 64 + (i * 60));
            [scrollview addSubview:columnView1];
            
            UILabel *descrlbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 195 + (i * 50), 83, 50)];
            [descrlbl setTextColor:[UIColor whiteColor]];
            [descrlbl setBackgroundColor:[UIColor clearColor]];
            [descrlbl setFont:[UIFont fontWithName: @"Helvetica Neue" size: 9.0f]];
            [descrlbl setText:descrS];
            [descrlbl setTextAlignment:NSTextAlignmentCenter];
            descrlbl.lineBreakMode = NSLineBreakByWordWrapping;
            descrlbl.numberOfLines = 0;
            [descrlbl sizeToFit];
            [scrollview addSubview:descrlbl];
            
            columnView2.frame = CGRectMake(171, 166, 1, 64 + (i * 60));
            [scrollview addSubview:columnView2];
            
            UILabel *creditlbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 195 + (i * 50), 60, 50)];
            [creditlbl setTextColor:[UIColor whiteColor]];
            [creditlbl setBackgroundColor:[UIColor clearColor]];
            [creditlbl setFont:[UIFont fontWithName: @"Helvetica Neue" size: 9.0f]];
            [creditlbl setText:debitS];
            [creditlbl setTextAlignment:NSTextAlignmentCenter];
            creditlbl.lineBreakMode = NSLineBreakByWordWrapping;
            creditlbl.numberOfLines = 0;
            [creditlbl sizeToFit];
            [scrollview addSubview:creditlbl];
            
            columnView3.frame = CGRectMake(241, 166, 1, 64 + (i * 60));
            [scrollview addSubview:columnView3];
            
            UILabel *debitlbl = [[UILabel alloc] initWithFrame:CGRectMake(270, 195 + (i * 50), 60, 50)];
            [debitlbl setTextColor:[UIColor whiteColor]];
            [debitlbl setBackgroundColor:[UIColor clearColor]];
            [debitlbl setFont:[UIFont fontWithName: @"Helvetica Neue" size: 9.0f]];
            [debitlbl setText:creditS];
            [debitlbl setTextAlignment:NSTextAlignmentCenter];
            debitlbl.lineBreakMode = NSLineBreakByWordWrapping;
            debitlbl.numberOfLines = 0;
            [debitlbl sizeToFit];
            [scrollview addSubview:debitlbl];
            
            scrollLength = (i * 60);
        
        }
        
        CGRect frame = self.backview.frame;
        frame.size.height = (330 + scrollLength);
        self.backview.frame = frame;
        
        [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 360 + scrollLength)];
        [self.scrollview setBounces:FALSE];
        
    }
    else
    {
        NSString *message = [dataContent objectForKey:@"message"];
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
    
    NSString *status_code = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"status_code"]];
    if ([status_code isEqualToString:@"500"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil userInfo:nil];
    
}


-(NSString *)formatDate:(NSString *)strdate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDate *dte = [dateFormat dateFromString:strdate];
    
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateResult = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte]];
    
    return dateResult;
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
