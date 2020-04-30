//
//  MenuViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize scrollview, backview, blockview, exitview;
@synthesize navigationController, controllers, screenType;
    
- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    navigationController = self.menuContainerViewController.centerViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"RefreshContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitClicked:) name:@"LOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyClicked:) name:@"HISTORY" object:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 590.0)];
    [self.scrollview setBounces:FALSE];
    
    backview.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:44.0/255.0 blue:149.0/255.0 alpha:1];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    blockview = [[UIView alloc] initWithFrame:CGRectMake(2, 322, 240, 98)];
    blockview.tag = 100;
    blockview.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:44.0/255.0 blue:149.0/255.0 alpha:1];
    
    exitview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 500, 235, 35)];
    exitview.tag = 200;
    
    [super viewWillAppear:animated];
}


- (void)refresh:(NSNotification *) obj
{
    
    screenType = (NSString *) [obj object];
    [[NSUserDefaults standardUserDefaults] setObject:screenType forKey:@"SCREENTYPE"];
    NSLog(@"screenType ::: %@",screenType);
    
    if ([screenType isEqualToString:@"DATA"])
    {
        UIButton *buttonToRemove1 = (UIButton*)[self.view   viewWithTag:100];
        UIButton *buttonToRemove2 = (UIButton*)[self.view   viewWithTag:200];
        
        [buttonToRemove1 removeFromSuperview];
        [buttonToRemove2 removeFromSuperview];
    }
    else if ([screenType isEqualToString:@"SMS"])
    {
        blockview = [[UIView alloc] initWithFrame:CGRectMake(2, 322, 240, 98)];
        blockview.tag = 100;
        blockview.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:44.0/255.0 blue:149.0/255.0 alpha:1];
        
        exitview =[[UIImageView alloc] initWithFrame:CGRectMake(5, 499, 235, 35)];
        exitview.tag = 200;
        exitview.image=[UIImage imageNamed:@"smsExit.png"];
        
        [self.scrollview addSubview:blockview];
        [self.scrollview addSubview:exitview];
    }
}
    
    
-(IBAction)homeClicked:(id)sender
{
    //NSLog(@"homeClicked");
    //[self buttonClicked:sender];
    screenType = [[NSUserDefaults standardUserDefaults] stringForKey:@"SCREENTYPE"];
    //NSLog(@"screenType ::: %@",screenType);
    
    if ([screenType isEqualToString:@"DATA"])
    {
        DatahomeViewController *datahomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DatahomeViewController"];
        controllers = [NSArray arrayWithObject:datahomeVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if ([screenType isEqualToString:@"SMS"])
    {
        SmshomeViewController *smshomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmshomeViewController"];
        controllers = [NSArray arrayWithObject:smshomeVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    
}

-(IBAction)playClicked:(id)sender
{
    //NSLog(@"playClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    screenType = [[NSUserDefaults standardUserDefaults] stringForKey:@"SCREENTYPE"];
    //NSLog(@"screenType ::: %@",screenType);
    
    if ([screenType isEqualToString:@"DATA"])
    {
        DatahomeViewController *datahomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DatahomeViewController"];
        controllers = [NSArray arrayWithObject:datahomeVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if ([screenType isEqualToString:@"SMS"])
    {
        SmsPlayViewController *playVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmsPlayViewController"];
        controllers = [NSArray arrayWithObject:playVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
}

-(IBAction)rechargeClicked:(id)sender
{
    //NSLog(@"rechargeClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    RechargeViewController *rechargeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RechargeViewController"];
    controllers = [NSArray arrayWithObject:rechargeVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}

-(IBAction)cashoutClicked:(id)sender
{
    //NSLog(@"cashoutClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    CashoutViewController *cashoutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CashoutViewController"];
    controllers = [NSArray arrayWithObject:cashoutVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}

-(IBAction)transferClicked:(id)sender
{
    //NSLog(@"transferClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    TransferViewController *transferVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferViewController"];
    controllers = [NSArray arrayWithObject:transferVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(IBAction)profileClicked:(id)sender
{
    //NSLog(@"profileClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    ProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    controllers = [NSArray arrayWithObject:profileVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


-(IBAction)passwordClicked:(id)sender
{
    //NSLog(@"passwordClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    PasswordViewController *passwordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
    controllers = [NSArray arrayWithObject:passwordVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


-(IBAction)historyClicked:(id)sender
{
    //NSLog(@"historyClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    HistoryViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    controllers = [NSArray arrayWithObject:profileVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


-(IBAction)tncClicked:(id)sender
{
    //NSLog(@"tncClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    TermsNconditionsViewController *tncVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsNconditionsViewController"];
    controllers = [NSArray arrayWithObject:tncVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(IBAction)htuClicked:(id)sender
{
    //NSLog(@"htuClicked");
    [[NSUserDefaults standardUserDefaults] setObject:@"MENU" forKey:@"FROM"];
    
    FaqViewController *faqVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqViewController"];
    controllers = [NSArray arrayWithObject:faqVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(IBAction)exitClicked:(id)sender
{
    //NSLog(@"exitClicked");
    //[self buttonClicked:sender];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOGGEDIN"];
    
    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    controllers = [NSArray arrayWithObject:loginVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}
   

-(void)buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    for (int i = 0; i < 7; i++)
    {
        //NSLog(@"buttonClicked :: %ld", (long)btn.tag);
        if (btn.tag == i)
        {
            btn.layer.shadowColor = [UIColor blackColor].CGColor;
            btn.layer.shadowOpacity = 0.5;
            btn.layer.shadowRadius = 1;
            btn.layer.cornerRadius = 2.0f;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithRed:(160/255.0) green:(97/255.0) blue:(5/255.0) alpha:1.0].CGColor;
            btn.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
        }
        else
        {
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
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


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
