//
//  DatahomeViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "DatahomeViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MatchListCell.h"
#import "MFSideMenu.h"

@interface DatahomeViewController ()

@end

@implementation DatahomeViewController

@synthesize lblbalance, jsonResponse, lblphone, balanceview;
@synthesize tableListView, matches, matchcode, scrollviewMain;
@synthesize slotHomeS, slotAwayS, homekit, awaykit, country;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    self.menuContainerViewController.panMode = MFSideMenuPanModeCenterViewController;
    
    [self setUpView];
    
    matches = [NSMutableArray array];
    
    
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
    //NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)setUpView
{
    
    [self.scrollviewMain setContentSize:CGSizeMake(self.scrollviewMain.frame.size.width, 640.0)];
    [self.scrollviewMain setBounces:FALSE];
    
    lblphone.text = [NSString stringWithFormat:@"No: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"]];
    
    [tableListView setDelegate:self];
    [tableListView setDataSource:self];
    
    [tableListView setBackgroundColor:[UIColor clearColor]];
    [tableListView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableListView setSeparatorColor:[UIColor clearColor]];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    lblbalance.text = [NSString stringWithFormat:@"₦ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"BALANCE"]];
    
    matchcode = @"";
    
    [SVProgressHUD showWithStatus:@"Checking for match fixtures ..."];
    
    [self fetchMatches:nil];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target: self selector: @selector(fetchMatches:) userInfo: nil repeats: YES];
    
    [super viewWillAppear:animated];
}


- (void)fetchMatches:(NSTimer*) t
{
    
    jsonResponse  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws matches];
                       
                       [self setJsonResponse:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processInitData];
                       });
                   });
}


-(void)processInitData
{
    /*
    NSNumber *success1 = [NSNumber numberWithInt:1];
    jsonResponse = @{ @"message":@{ @"status":@"", @"date":@"07/30/2016", @"time":@"09:00", @"fixtures":@"South China (Hkg) vs Juventus (Ita)", @"scores":@"", @"matchcode":@"1989234" }, @"success":success1 };
    jsonResponse = @{ @"message":@"token expired", @"status_code":@"500" };
    */
    
    NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *success = [dataContent objectForKey:@"success"];
    //NSLog(@"success ::: %@",success);
    
    success = [NSString stringWithFormat:@"%@",success];
    
    if ([success isEqualToString:@"1"])
    {
        [matches removeAllObjects];
        
        NSArray *rawmatches = [dataContent objectForKey:@"message"];
        //NSLog(@"rawmatches ::: %@",rawmatches);
        [matches addObjectsFromArray:rawmatches];
    }
    else
    {
        NSString *messageError = [dataContent objectForKey:@"message"];
        [self showSelfDismissingAlertViewWithMessage:messageError];
    }
    
    
    if ([[self matches] count] != 0)
    {
        [self.tableListView reloadData];
    }
    
    NSString *status_code = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"status_code"]];
    if ([status_code isEqualToString:@"500"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOGGEDIN"];
        [self performSegueWithIdentifier:@"UnwindFromFixturesToLogin" sender:self];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self matches] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MatchListCell";
    
    MatchListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *dataContent = [[self matches] objectAtIndex:indexPath.row];
    [cell.dateLabel setText:[dataContent objectForKey:@"date"]];
    [cell.timeLabel setText:[dataContent objectForKey:@"time"]];
    
    
    NSString *status = [dataContent objectForKey:@"status"];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([status rangeOfCharacterFromSet:notDigits].location == NSNotFound && (![status isEqualToString:@""]))
    {
        [cell.statusLabel setText:[NSString stringWithFormat:@"%@'",status]];
    }
    else
    {
        [cell.statusLabel setText:status];
    }
     
    
    NSArray *teamString = [[[dataContent objectForKey:@"fixtures"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" vs "];
    [cell.homeLabel setText:[teamString objectAtIndex:0]];
    [cell.awayLabel setText:[teamString objectAtIndex:1]];
    
    
    id scoresValue = [dataContent objectForKey:@"scores"];
    NSString *scores = @"";
    if (scoresValue == [NSNull null] )
    {
        [cell.homeScoreLabel setText:@""];
        [cell.awayScoreLabel setText:@""];
    }
    else
    {
        scores = (NSString *)scoresValue;
        
        if([scores isEqualToString:@""])
        {
            [cell.homeScoreLabel setText:@""];
            [cell.awayScoreLabel setText:@""];
        }
        else
        {
            NSArray *scoreString = [[scores stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" - "];
            
            [cell.homeScoreLabel setText:[scoreString objectAtIndex:0]];
            [cell.awayScoreLabel setText:[scoreString objectAtIndex:1]];
        }
    }
    
    NSString *homekitS = [self getHomeKit:[teamString objectAtIndex:0]];
    NSString *awaykitS = [self getAwayKit:[teamString objectAtIndex:1]];
    
    [cell.homeJersey setImage:[UIImage imageNamed:homekitS]];
    [cell.awayJersey setImage: [UIImage imageNamed:awaykitS]];
     
    
    return cell;
    
}


-(NSString *)getHomeKit:(NSString *)clubName
{
    NSString *kitColor = @"";
    
    if ([clubName isEqualToString:@"Arsenal"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Bournemouth"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Burnley"])
        kitColor = @"claret.png";
    else if ([clubName isEqualToString:@"Chelsea"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"Crystal Palace"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"Everton"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"Hull City"])
        kitColor = @"orange.png";
    else if ([clubName isEqualToString:@"Leicester"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"Liverpool"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Manchester City"])
        kitColor = @"skyblue.png";
    else if ([clubName isEqualToString:@"Manchester United"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Middlesbrough"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Southampton"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Stoke City"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Sunderland"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Swansea"])
        kitColor = @"white.png";
    else if ([clubName isEqualToString:@"Tottenham"])
        kitColor = @"white.png";
    else if ([clubName isEqualToString:@"Watford"])
        kitColor = @"yellow.png";
    else if ([clubName isEqualToString:@"West Brom"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"West Ham"])
        kitColor = @"claret.png";
    else
        kitColor = @"home.png";
    
    return kitColor;
    
}


-(NSString *)getAwayKit:(NSString *)clubName
{
    NSString *kitColor = @"";
    
    if ([clubName isEqualToString:@"Arsenal"])
        kitColor = @"yellow.png";
    else if ([clubName isEqualToString:@"Bournemouth"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"Burnley"])
        kitColor = @"skyblue.png";
    else if ([clubName isEqualToString:@"Chelsea"])
        kitColor = @"white.png";
    else if ([clubName isEqualToString:@"Crystal Palace"])
        kitColor = @"yellow.png";
    else if ([clubName isEqualToString:@"Everton"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"Hull City"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"Leicester"])
        kitColor = @"red.png";
    else if ([clubName isEqualToString:@"Liverpool"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"Manchester City"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"Manchester United"])
        kitColor = @"white.png";
    else if ([clubName isEqualToString:@"Middlesbrough"])
        kitColor = @"blue.png";
    else if ([clubName isEqualToString:@"Southampton"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"Stoke City"])
        kitColor = @"skyblue.png";
    else if ([clubName isEqualToString:@"Sunderland"])
        kitColor = @"pink.png";
    else if ([clubName isEqualToString:@"Swansea"])
        kitColor = @"skyblue.png";
    else if ([clubName isEqualToString:@"Tottenham"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"Watford"])
        kitColor = @"white.png";
    else if ([clubName isEqualToString:@"West Brom"])
        kitColor = @"black.png";
    else if ([clubName isEqualToString:@"West Ham"])
        kitColor = @"white.png";
    else
        kitColor = @"away.png";
    
    return kitColor;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dataContent = [[self matches] objectAtIndex:indexPath.row];
    NSArray *teamString = [[[dataContent objectForKey:@"fixtures"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" vs "];
    slotHomeS = [teamString objectAtIndex:0];
    slotAwayS = [teamString objectAtIndex:1];
    
    matchcode = [dataContent objectForKey:@"matchcode"];
    
    id countryValue = [dataContent objectForKey:@"country"];
    if (countryValue == [NSNull null] ) country = @"";
    else country = (NSString *)countryValue;
    
    homekit = [self getHomeKit:slotHomeS];
    awaykit = [self getAwayKit:slotAwayS];
 
    [self performSegueWithIdentifier:@"DataPlaySegue" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DataPlaySegue"])
    {
        DataPlayViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like ...
        [vc setMatchcode:matchcode];
        [vc setSlotHomeS:slotHomeS];
        [vc setSlotAwayS:slotAwayS];
        [vc setHomekit:homekit];
        [vc setAwaykit:awaykit];
        [vc setCountry:country];
        
    }
}



- (void)showSelfDismissingAlertViewWithMessage:(NSString *)message
{
    
    
    CGSize scrSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize textSize = [self getSizeForText:message withFont:[UIFont fontWithName:@"Helvetica" size:15] maxSize:CGSizeMake(280, 200)];
    
    CGRect loadingFrame = CGRectMake(scrSize.width/2 - textSize.width/2 - 10, scrSize.height/2 - textSize.height/2 - (-150), textSize.width + 20, textSize.height + 15);
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


- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
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


- (IBAction)unwindToFixtures:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"::: fixtures from play :::");
}

@end
