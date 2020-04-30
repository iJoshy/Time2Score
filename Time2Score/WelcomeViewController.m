//
//  WelcomeViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HelperClass.h"

@interface WelcomeViewController ()
{
    NSString *title;
}

@end

@implementation WelcomeViewController

@synthesize scrollview, footerview, backview;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 590.0)];
    [self.scrollview setBounces:FALSE];
    
    
    if ([[UIScreen mainScreen] bounds].size.height <= 480)
    {        
        self.footerview.frame = CGRectMake(0, 430, 320, 50);
    }
    
   
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.backview addSubview:backgroundView];
    
}


-(IBAction)btn1Clicked:(id)sender
{
    NSLog(@"btn1Clicked");
    [self performSegueWithIdentifier: @"LoginSegue" sender:self];
}

-(IBAction)btn2Clicked:(id)sender
{
    NSLog(@"btn2Clicked");
    //NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    //[[UIApplication sharedApplication] openURL:url];
    
    title = @"Superior Bet";
    [self presentWebViewController:@"http://www.superiorbetng.com/MobilePlatform/home"];
}

-(IBAction)btn3Clicked:(id)sender
{
    NSLog(@"btn3Clicked");
    //NSURL *url = [NSURL URLWithString:@"http://www.biggamesng.com"];
    //[[UIApplication sharedApplication] openURL:url];
    
    title = @"Big Games";
    [self presentWebViewController:@"http://www.biggamesng.com"];
}

-(IBAction)btn4Clicked:(id)sender
{
    NSLog(@"btn4Clicked");
    //NSURL *url = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/sportonline_uk_edition/football/rss.xml"];
    //[[UIApplication sharedApplication] openURL:url];
    
    title = @"Sport News";
    [self presentWebViewController:@"http://newsrss.bbc.co.uk/rss/sportonline_uk_edition/football/rss.xml"];
}

-(IBAction)btn5Clicked:(id)sender
{
    NSLog(@"btn5Clicked");
    [self showSelfDismissingAlertViewWithMessage:@"Coming Soon!"];
}


- (void)presentWebViewController:(NSString *)address
{
    
    NSURL *URL = [NSURL URLWithString:address];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.title = title;
    [self presentViewController:webViewController animated:YES completion:NULL];
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

@end
