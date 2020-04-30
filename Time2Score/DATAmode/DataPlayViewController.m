//
//  DataPlayViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "DataPlayViewController.h"

@interface DataPlayViewController ()

@end

@implementation DataPlayViewController

@synthesize scrollview, slotsPricelbl, btnview, homekit, awaykit, country;
@synthesize jsonResponse, balanceview, scrollviewMain, homekitImg, dialogslots;
@synthesize lblbalance, matchcode, slotBtn, statsview, awaykitImg;
@synthesize slotHome, slotAway, slotHomeTxt, slotAwayTxt, lblawayscore, lblhomescore;
@synthesize slotAwayLbl, slotHomeLbl, slotAwayS, slotHomeS, jsonResponse2, jsonResponse3;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    pos = 0;
    slots = 0;
    
    [self setUpView];
    
    [super viewDidLoad];
    
}


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(800.0, 93.0)];
    [self.scrollview setBounces:FALSE];
    
    [self.scrollviewMain setContentSize:CGSizeMake(self.scrollviewMain.frame.size.width, 680.0)];
    [self.scrollviewMain setBounces:FALSE];
    
    
    [self getBalance];
    
    slotBtn = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 40; i++)
    {
        [self.slotBtn addObject:@"0"];
    }
    
    slotHome = [[NSMutableArray alloc]init];
    slotAway = [[NSMutableArray alloc]init];
    
    [slotHome addObjectsFromArray:@[@"1 (0 - 4:59)",@"3 (5 - 9:59)",@"5 (10 - 14:59)",@"7 (15 - 19:59)",@"9 (20 - 24:59)",@"11 (25 - 29:59)",
                                     @"13 (30 - 34:59)",@"15 (35 - 39:59)",@"17 (40 - 44:59)",@"19 (45 - 49:59 Extra)",@"21 (45 - 49:59)",
                                     @"23 (50 - 54:59)",@"25 (55 - 59:59)",@"27 (60 - 64:59)",@"29 (65 - 69:59)",@"31 (70 - 74:59)",
                                     @"33 (75 - 79:59)",@"35 (80 - 84:59)",@"37 (85 - 89:59)",@"39 (90 - 94:59)"]];
    
    [slotAway addObjectsFromArray:@[@"2 (0 - 4:59)",@"4 (5 - 9:59)",@"6 (10 - 14:59)",@"8 (15 - 19:59)",@"10 (20 - 24:59)",@"12 (25 - 29:59)",
                                    @"14 (30 - 34:59)",@"16 (35 - 39:59)",@"18 (40 - 44:59)",@"20 (45 - 49:59 Extra)",@"22 (45 - 49:59)",
                                    @"24 (50 - 54:59)",@"26 (55 - 59:59)",@"28 (60 - 64:59)",@"30 (65 - 69:59)",@"32 (70 - 74:59)",
                                    @"34 (75 - 79:59)",@"36 (80 - 84:59)",@"38 (85 - 89:59)",@"40 (90 - 94:59)"]];
    
    UITapGestureRecognizer *twTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    twTapGesture.cancelsTouchesInView = NO;
    [self.statsview.superview addGestureRecognizer:twTapGesture];
    [self.balanceview.superview addGestureRecognizer:twTapGesture];
    
    //NSLog(@"slotHome %@\n",slotHome);
    //NSLog(@"slotAway %@",slotAway);
    
    slotHomeLbl.text = slotHomeS;
    slotAwayLbl.text = slotAwayS;
    
    homekitImg.image = [UIImage imageNamed:homekit];
    awaykitImg.image = [UIImage imageNamed:awaykit];
    
    [self currentslots:nil];
}


-(IBAction)homeBtnClicked:(id)sender
{
    //NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)getBalance
{
    lblbalance.text = [NSString stringWithFormat:@"₦ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"BALANCE"]];
}


- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(self.statsview.frame, point))
        {
            [self statisticsClicked];
        }
        else if (CGRectContainsPoint(self.balanceview.frame, point))
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HISTORY" object:nil userInfo:nil];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target: self selector: @selector(currentslots:) userInfo: nil repeats: YES];
    
    [super viewWillAppear:animated];
}


-(void)currentslots:(NSTimer*) t
{
    
    //NSLog(@":::: checking currrent slots ::::");
    
    
    NSString *matchcodeS = matchcode;
    
    jsonResponse  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws currentslot:matchcodeS];
                       
                       [self setJsonResponse:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processCurrentSlots];
                       });
                 
  });
    
}

-(void)processCurrentSlots
{
    /*
    NSNumber *one = [NSNumber numberWithInt:1];
    NSNumber *slot1 = [NSNumber numberWithInt:7];
    NSNumber *slot2 = [NSNumber numberWithInt:14];
    jsonResponse = @{ @"message":@"Success", @"slot1":slot1, @"slot2":slot2, @"success":one };
    jsonResponse = @{ @"message":@"Token has expired", @"status_code":@"500" };
    */
    
    
    //NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    
    //NSLog(@"message ::: %@",message);
    //NSLog(@"success ::: %@",success);
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        NSString *slot1 = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"slot1"]];
        NSString *slot2 = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"slot2"]];
        
        lblhomescore.text = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"homegoals"]];
        lblawayscore.text = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"awaygoals"]];
        
        [self upadteSlots:slot1:slot2];
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
    
    if ([[message lowercaseString] isEqualToString:@"token has expired"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOGGEDIN"];
        [self performSegueWithIdentifier:@"UnwindFromPlayToLogin" sender:self];
    }
    
}


-(void)upadteSlots:(NSString *)slot1 :(NSString *)slot2
{
    int slotlen = [slot2 intValue];
    
    for (int i = slotlen; i >= 1; i--)
    {
        UIButton *button = (UIButton *)[scrollview viewWithTag:i];
        [button setHidden:YES];
    }
    
    pos = slotlen;
    int x = pos*20;
    [scrollview scrollRectToVisible:CGRectMake(x, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    
}



-(IBAction)scrollRight
{
    //NSLog(@"Pos: %i",pos);
    if(pos <= 24)
    {
        pos += 2;
        int x = pos*20;
        [scrollview scrollRectToVisible:CGRectMake(x, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
        //NSLog(@"Position: %i x: %i",pos,x);
    }
}


-(IBAction)scrollLeft
{
    if(pos > 0)
    {
        pos -= 2;
        int x = pos*20;
        [scrollview scrollRectToVisible:CGRectMake(x, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
        //NSLog(@"Position: %i x: %i",pos,x);
    }
}


-(IBAction)statisticsClicked
{
    [self performSegueWithIdentifier: @"StatisticsSegue" sender:self];
}


-(IBAction)buttonClicked:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSInteger btnNo = button.tag;
    
    int btnPos = (int)btnNo;
    int arrayPos = btnPos - 1;
    
    //NSLog(@"button clicked :: %d",btnPos);
    NSString *value = [slotBtn objectAtIndex:arrayPos];
    int status = [value intValue];
    
    if (status == 1)
    {
        if ( ( btnPos % 2 ) != 0 )
        {
            [button setBackgroundColor:[UIColor colorWithRed:19.0/255.0 green:23.0/255.0 blue:124.0/255.0 alpha:1]];
        }
        else
        {
            [button setBackgroundColor:[UIColor redColor]];
        }
        
        [slotBtn replaceObjectAtIndex:arrayPos withObject:@"0"];
        
        if (slots != 0)
            slots -= 1;
    }
    else if (status == 0)
    {
        [button setBackgroundColor:[UIColor grayColor]];
        
        [slotBtn replaceObjectAtIndex:arrayPos withObject:@"1"];
        
        slots += 1;
    }
    
    [self displaySlot];
    slotsPricelbl.text = [NSString stringWithFormat:@"₦ %d",(slots * 100)];
    
}


-(void)displaySlot
{
    NSMutableString *indices1 = [NSMutableString stringWithCapacity:1];
    NSMutableString *indices2 = [NSMutableString stringWithCapacity:1];
    
    int slotBtnlen = (int)[slotBtn count];
    for (int i = 1; i <= slotBtnlen; i++)
    {
        NSString *selected = [slotBtn objectAtIndex:(i-1)];
        if ([selected intValue] == 1)
        {
            if ( ( i % 2 ) != 0 )
            {
                [indices1 appendFormat:@"%@\n",[slotHome objectAtIndex:((i-1)/2)]];
            }
            else
            {
                [indices2 appendFormat:@"%@\n",[slotAway objectAtIndex:((i-2)/2)]];
            }            
        }
    }
    
    slotHomeTxt.text = indices1;
    slotAwayTxt.text = indices2;
}


-(IBAction)sendClicked:(id)sender
{
    
    NSString *selectedslots = @"";
    int slotBtnlen = (int)[slotBtn count];
    for (int i = 0; i < slotBtnlen; i++)
    {
        NSString *selected = [slotBtn objectAtIndex:i];
        if ([selected intValue] == 1)
        {
            selectedslots = [NSString stringWithFormat:@"%@,%d",selectedslots,(i+1)];
        }
    }
    
    
    if ([selectedslots isEqualToString:@""])
    {
        [self showSelfDismissingAlertViewWithMessage:@"One or more slots should be selected"];
    }
    else
    {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Request"
                                                           message:@"Would you like to proceed with this request?"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Yes",nil];
        [theAlert show];
        
        dialogslots = [selectedslots substringFromIndex:1];
        //NSLog(@"selected slots  :::: %@",dialogslots);
        
    }
    
}


- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self callService];
    }
}


-(void)callService
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    //NSLog(@"token - %@",token);
    //NSLog(@"slot - %@",dialogslots);
    //NSLog(@"matchcode - %@",matchcode);
    
    
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    jsonResponse2  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
       {
           WebServiceCall *ws = [[WebServiceCall alloc] init];
           
           NSDictionary *response = [ws play:token:matchcode:dialogslots];
           
           [self setJsonResponse2:response];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               //[SVProgressHUD dismiss];
               [self processInitData];
           });
       });
    
}


-(void)processInitData
{
    
    //NSLog(@"slot reponse : %@",[self jsonResponse2]);
    
    NSDictionary * dataContent = [self jsonResponse2];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    
    /*
    NSLog(@"message ::: %@",message);
    NSLog(@"success ::: %@",success);
    NSLog(@"matchcode ::: %@",matchcode);
     */
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        [self walletBalance];
    }
    else
    {
        [SVProgressHUD dismiss];
        
        [self showSelfDismissingAlertViewWithMessage:message];
        
        if ([[message lowercaseString] isEqualToString:@"token has expired"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOGGEDIN"];
            [self performSegueWithIdentifier:@"UnwindFromPlayToLogin" sender:self];
        }
        
    }
    
}


-(void)walletBalance
{
    
    jsonResponse3  = nil;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws balance:token];
                       
                       [self setJsonResponse3:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processWalletBalance];
                       });
                   });
}


-(void)processWalletBalance
{
    //NSLog(@" balance : %@",[self jsonResponse3]);
    
    NSDictionary * dataContent3 = [self jsonResponse3];
    NSString *success = [dataContent3 objectForKey:@"success"];

    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        NSString *newBalance = [dataContent3 objectForKey:@"newBal"];
        [[NSUserDefaults standardUserDefaults] setObject:newBalance forKey:@"BALANCE"];
        
        [self performSegueWithIdentifier: @"PlayAlertSegue" sender:self];
        [self getBalance];
        
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PlayAlertSegue"])
    {
        // Get reference to the destination view controller
        AlertViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setFromWhere:@"PLAY"];
        [vc setAlerttitle:@"Confirmation"];
        [vc setMessage:[NSString stringWithFormat:@"Your placed bet has been confirmed successfully.\n Slots %@.\n Place. Bet. Win.",dialogslots]];
    }
    else if ([[segue identifier] isEqualToString:@"StatisticsSegue"])
    {
        StatisticsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setMatchcode:matchcode];
        [vc setSlotHomeS:slotHomeS];
        [vc setSlotAwayS:slotAwayS];
        [vc setCountry:country];
        
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(myTimer)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
}


@end
