//
//  SmshomeViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "SmshomeViewController.h"

@interface SmshomeViewController ()

@end

@implementation SmshomeViewController

@synthesize scrollview;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    self.menuContainerViewController.panMode = MFSideMenuPanModeCenterViewController;
    
    [self setUpView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)homeBtnClicked:(id)sender
{
    NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"SMS" forKey:@"SCREEN"];
    
    [super viewWillAppear:animated];
}

-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 590.0)];
    [self.scrollview setBounces:FALSE];
    
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
    

-(IBAction)registerClicked:(id)sender
{
    NSLog(@"registerClicked");
    [self showSMS:@"SCORETIME"];
}

-(IBAction)balanceClicked:(id)sender
{
    NSLog(@"balanceClicked");
    [self showSMS:@"BALANCE"];
}

-(IBAction)listClicked:(id)sender
{
    NSLog(@"listClicked");
    [self showSMS:@"GAMES"];
}

-(IBAction)playClicked:(id)sender
{
    NSLog(@"playClicked");
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HOME" forKey:@"FROM"];
    
    [self performSegueWithIdentifier: @"PlaySegue" sender:self];
}

-(IBAction)jackpotClicked:(id)sender
{
    NSLog(@"jackpotClicked");
    [self performSegueWithIdentifier: @"JackpotSegue" sender:self];
}

-(IBAction)winningsClicked:(id)sender
{
    NSLog(@"winningsClicked");
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HOME" forKey:@"FROM"];
    
    [self performSegueWithIdentifier: @"CashoutSegue" sender:self];
}

-(IBAction)transferClicked:(id)sender
{
    NSLog(@"transferClicked");
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HOME" forKey:@"FROM"];
    
    [self performSegueWithIdentifier: @"TransferSegue" sender:self];
}

-(IBAction)rechargeClicked:(id)sender
{
    NSLog(@"rechargeClicked");
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HOME" forKey:@"FROM"];
    
    [self performSegueWithIdentifier: @"RechargeSegue" sender:self];
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


@end
