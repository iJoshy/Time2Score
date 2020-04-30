//
//  StatisticsViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "StatisticsViewController.h"
#import "CLTickerView.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

@synthesize scrollview, lblbalance, backview, matchcode, country, clubstats;
@synthesize jsonResponse, lblphone, balanceview, leaguetableview, jsonResponse2;
@synthesize slotAwayS, slotHomeS, lblnobet, lblhome, lblaway, lblmatch, fBbutton;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    if ([country isEqualToString:@"None"])
    {
        UIButton *buttonToRemove = (UIButton*)[scrollview viewWithTag:380];
        [buttonToRemove removeFromSuperview];
    }
    else
    {
        clubstats = [[NSMutableArray alloc]init];
        leaguetableview.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:.6];
        [self addLeaguetableview];
    }
    
    UITapGestureRecognizer *twTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    twTapGesture.cancelsTouchesInView = NO;
    [self.balanceview.superview addGestureRecognizer:twTapGesture];
    
    fBbutton.layer.cornerRadius = 3.0f;
    fBbutton.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:23.0/255.0 blue:124.0/255.0 alpha:1];
    
    [super viewDidLoad];
    
}


-(IBAction)fbClicked:(id)sender
{
    NSLog(@"fbClicked");
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/superiorbet"];
    [[UIApplication sharedApplication] openURL:url];
}


-(IBAction)homeBtnClicked:(id)sender
{
    //NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
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


-(void)addLeaguetableview
{
    
    NSString *countryS = country;
    //NSLog(@"countryS :: %@",country);
    
    [SVProgressHUD showWithStatus:@"loading ..."];
    jsonResponse2  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws leaguetable:countryS];
                       
                       [self setJsonResponse2:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self setLeaguetableview];
                       });
                   });
    
}


-(void)setLeaguetableview
{
    
    //NSLog(@" league table : %@",[self jsonResponse2]);
    
    NSDictionary * dataContent = [self jsonResponse2];
    NSArray *leaguetable = [dataContent objectForKey:@"leaguetable"];
    
    //NSLog(@"leaguetable ::: %@",leaguetable);
    [clubstats addObjectsFromArray:leaguetable];
    
    
    NALLabelsMatrix* matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(8, 422, 310, 80) andColumnsWidths:[[NSArray alloc] initWithObjects:@35,@100,@35,@35,@35,@35,@35, nil]];
    
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"#", @"Teams", @"P", @"W", @"D", @"L", @"Pts", nil]];
    
    for (int i=0; i < [clubstats count]; i++)
    {
        NSDictionary *eachclub = [clubstats objectAtIndex:i];
        
        NSString *position = [eachclub objectForKey:@"position"];
        NSString *team = [eachclub objectForKey:@"team"];
        NSString *P = [eachclub objectForKey:@"p"];
        NSString *W = [eachclub objectForKey:@"w"];
        NSString *D = [eachclub objectForKey:@"d"];
        NSString *L = [eachclub objectForKey:@"l"];
        NSString *Pts = [eachclub objectForKey:@"points"];
        
        [matrix addRecord:[[NSArray alloc] initWithObjects:position, team, P, W, D, L, Pts, nil]];
    }
    
    /*
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"1", @"  Arsenal", @"0", @"0", @"0", @"0", @"0", nil]];
    */
    
    [self.scrollview addSubview:matrix];
    
    
}

-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 900.0)];
    [self.scrollview setBounces:FALSE];
    
    
    lblphone.text = [NSString stringWithFormat:@"No: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"]];
    [self getBalance];
    
    [self callService];
}


-(void)getBalance
{
    lblbalance.text = [NSString stringWithFormat:@"₦ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"BALANCE"]];
}


-(void)callService
{
    
    NSString *matchcodeS = matchcode;
    
    [SVProgressHUD showWithStatus:@"loading ..."];
    jsonResponse  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws statistics:matchcodeS];
                       
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
    NSString *status = [dataContent objectForKey:@"status"];
    
    NSLog(@"message ::: %@",message);
    NSLog(@"success ::: %@",success);
    NSLog(@"status ::: %@",status);
    NSLog(@"matchcode ::: %@",matchcode);
    
    success = [NSString stringWithFormat:@"%@",success];
    status = [NSString stringWithFormat:@"%@",status];
    
    if ([success isEqualToString:@"1"] )
    {
        
            NSString *home = [dataContent objectForKey:@"home"];
            NSString *homegoals = [dataContent objectForKey:@"homegoals"];
            NSString *homegoalmins = [dataContent objectForKey:@"homegoalmins"];
            
            //NSLog(@"home ::: %@",home);
            //NSLog(@"homegoals ::: %@",homegoals);
            //NSLog(@"homegoalmins ::: %@",homegoalmins);
        
            NSString *percentagewin = [dataContent objectForKey:@"percentagewin"];
            
            NSString *away = [dataContent objectForKey:@"away"];
            NSString *awaygoals = [dataContent objectForKey:@"awaygoals"];
            NSString *awaygoalmins = [dataContent objectForKey:@"awaygoalmins"];
            
            //NSLog(@"away ::: %@",away);
            //NSLog(@"awaygoals ::: %@",awaygoals);
            //NSLog(@"awaygoalmins ::: %@",awaygoalmins);
            
            if(([home integerValue] == 0) && ([away integerValue] == 0))
            {
                message = @"There is no bet on this game";
                lblnobet.text = message;
                lblmatch.text = [NSString stringWithFormat:@"%@ : %@\t",slotHomeS,slotAwayS];
            }
            else
            {
                
                home = [NSString stringWithFormat:@"%.1f",[home floatValue]];
                away = [NSString stringWithFormat:@"%.1f",[away floatValue]];
                
                [self plotGraph:homegoals :homegoalmins :home :awaygoals :awaygoalmins :away];
                lblnobet.text = [NSString stringWithFormat:@"Win : %@%%",percentagewin];
                lblhome.text = [NSString stringWithFormat:@"Home : %@%%",home];
                lblaway.text = [NSString stringWithFormat:@"Away : %@%%",away];
                lblmatch.text = @"";
            }
        
    }
    else
    {
        lblmatch.text = [NSString stringWithFormat:@"%@ : %@\t",slotHomeS,slotAwayS];
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
    
    NSString *status_code = [dataContent objectForKey:@"status_code"];
    if ([status_code isEqualToString:@"500"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOGGEDIN"];
        [self performSegueWithIdentifier:@"UnwindFromStatisticsToLogin" sender:self];
    }
    
}



-(void)plotGraph:(NSString *)homegoals :(NSString *)homegoalmins :(NSString *)home :(NSString *)awaygoals :(NSString *)awaygoalmins :(NSString *)away
{
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:[away floatValue] color:PNWhite description:@""],
                       [PNPieChartDataItem dataItemWithValue:[home floatValue] color:PNRed description:@""],                       
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 175, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Helvetica Neue" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = YES;
    [self.pieChart strokeChart];
    
    [self.scrollview addSubview:self.pieChart];
    
    CLTickerView *ticker = [[CLTickerView alloc] initWithFrame:lblmatch.frame];
    ticker.marqueeStr = [NSString stringWithFormat:@"%@  %@  %@ : %@  %@  %@",homegoalmins,slotHomeS,homegoals,awaygoals,slotAwayS,awaygoalmins];
    ticker.marqueeFont = [UIFont boldSystemFontOfSize:11];
    
    [self.scrollview addSubview:ticker];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
