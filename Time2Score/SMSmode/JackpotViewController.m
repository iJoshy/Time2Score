//
//  JackpotViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "JackpotViewController.h"

@interface JackpotViewController ()

@end

@implementation JackpotViewController

@synthesize scrollview, txtview, btnview;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
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


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 320.0)];
    [self.scrollview setBounces:FALSE];
    
    txtview.layer.sublayerTransform = CATransform3DMakeTranslation(20.0f, 0.0f, 0.0f);
    
}


-(IBAction)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    
    if (txtview.text.length == 0)
    {
        [self showSelfDismissingAlertViewWithMessage:@"This field is required"];
    }
    else
    {
        NSString *file = [NSString stringWithFormat:@"JACKPOT %@",txtview.text];
        [self showSMS:file];
    }
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end