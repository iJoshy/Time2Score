//
//  FaqViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "FaqViewController.h"
#import "MFSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "WebServiceCall.h"
#import <CoreGraphics/CoreGraphics.h>

@interface FaqViewController ()

@end

@implementation FaqViewController

@synthesize scrollView, tempArray, nf;
@synthesize dateLbl, narrationLbl, amountLbl;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 600.0)];
    [self.scrollView setBounces:FALSE];
    
    accordion = [[AccordionView alloc] initWithFrame:CGRectMake(10, 10, 300, [[UIScreen mainScreen] bounds].size.height)];
    
    nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"₦"];
    
    tempArray = @[@{@"question":@"What is Time2Score", @"answer":@"\nTime2Score is a live sports betting game where a player select’s  slot(s)  based on 5 minutes intervals;  in order to predict the timing of goals in a football match."},
                  @{@"question":@"How Much Can a Player Win/ How Much is the Jackpot", @"answer":@"\nA player can win the Jackpot of up to N1 Million and more."},
                  @{@"question":@"How to Register", @"answer":@"\nStep 1: Download Time2score app from Google playstore or Apple store.\nStep 2: Click on the register icon and fill in your correct details. Upon successful registration you can play."},
                  @{@"question":@"How to Play", @"answer":@"\n1. Buy a Time2Score scratch card/ voucher (game credit) and load your wallet.\n2. Select the match of your choice from the current live match fixtures.\n3. Choose your slot number(s) that corresponds with the time you predict a goal will be scored during the match.\n4. Click send to enter your slot(s) selections."},
                  @{@"question":@"What Does it Cost to Play", @"answer":@"\nIn a match there are 40 slots in 5 minute intervals and each slot costs N100.\nIf you play via the SMS platform, there is an additional N10 deducted from your airtime."},
                  @{@"question":@"How to Recharge", @"answer":@"\nPurchase the Time2score scratch card/voucher (game credit) from any of our agents or outlets, click on the RECHARGE option and enter the voucher pin number. Your wallet will be credited."},
                  @{@"question":@"How do I Know my Winnings/Balance", @"answer":@"\nClick on Account Details option in the menu and it will display all your balances in your wallet."},
                  @{@"question":@"How to Get Winnings", @"answer":@"\nAll payments for winnings are made within 24hrs after request.\nPlayers can only cash-out from their winnings balance.\nClick on the CASH-OUT option, enter amount to cash-out then select preferred mobile money option and submit.\nCharges might be incurred depending on the mobile money option chosen."},
                  @{@"question":@"How to View Ticket", @"answer":@"\nClick on the Account Details option and your ticket history will be displayed"},
                  @{@"question":@"How to Transfer Credit", @"answer":@"\nStep 1: Click on Transfer Credit option under MENU\nStep 2: Enter the recipient’s phone number\nStep 3: Enter the amount you want to transfer\nStep 4: Click the SEND button"},
                  @{@"question":@"HOW TO CASHOUT WITH READYCASH", @"answer":@"\nTo claim your winnings via ReadyCash, Dial *732# with the phone number that you used to register on the Time2Score app or download the ReadyCash mobile money app from Google play store.\nFor more info call 07052583804, email: readycash@parkwayprojects.com"},
                  @{@"question":@"To contact us", @"answer":@"\nCall -  070040004000\nEmail -  support@superiorgamesng.com\nWhatsapp - 07031729994\nFacebook – www.facebook.com/superiorbet\nTwitter - @superiorbetng"}];
    
    //NSLog(@" reponse : %@",[self tempArray]);
    
    [self processHistory];
    
}


-(IBAction)homeBtnClicked:(id)sender
{
    NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)processHistory
{
    
    NSUInteger count = [tempArray count];
    //NSLog(@" reponse : %@",[self tempArray]);
    NSLog(@" count : %lu",(unsigned long)count);
    
    for (int i = 0; i < count; i++)
    {
        
        NSDictionary *eachArray = [tempArray objectAtIndex:i];
        
        UIButton *space = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 0, 1)];
        space.backgroundColor = [UIColor lightGrayColor];
        
        UIView *space1 = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 0, 1)];
        space1.backgroundColor = [UIColor greenColor];
        
        UIView *blank = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 5)];
        space1.backgroundColor = [UIColor whiteColor];
        
        [space addSubview:blank];
        [space1 addSubview:blank];
        
        UIButton *header = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 45)];
        header.backgroundColor = [UIColor whiteColor];
        
        dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 300, 45)];
        dateLbl.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        dateLbl.textColor = [UIColor colorWithRed:19.0/255.0 green:23.0/255.0 blue:124.0/255.0 alpha:1];
        dateLbl.backgroundColor = [UIColor whiteColor];
        [dateLbl setText:[eachArray objectForKey:@"question"]];
        
        UIImageView *usernameicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"faqicon.png"]];
        usernameicon.frame = CGRectMake(0.0, 13.0, 20.0, 20.0);
        usernameicon.contentMode = UIViewContentModeCenter;
 
        
        [header addSubview:usernameicon];
        [header addSubview:dateLbl];
        
        UITextView *txtview = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, 300, 70)];
        txtview.font = [UIFont fontWithName:@"Helvetica" size:9.0];
        txtview.textColor = [UIColor blackColor];
        txtview.text = [eachArray objectForKey:@"answer"];
        txtview.textAlignment = NSTextAlignmentJustified;
        txtview.backgroundColor = [UIColor whiteColor];
        
        [accordion addHeader:header withView:txtview];
        [accordion addHeader:space withView:space1];
    }
    
    [accordion setNeedsLayout];
    [accordion setAllowsMultipleSelection:NO];
    [accordion setAllowsEmptySelection:YES];
    
    [self.scrollView addSubview:accordion];
    
}


- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
