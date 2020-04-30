//
//  TermsNconditionsViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "TermsNconditionsViewController.h"

@interface TermsNconditionsViewController ()

@end

@implementation TermsNconditionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadWebView];
    
    self.navigationController.navigationBarHidden = YES;
}


-(IBAction)homeBtnClicked:(id)sender
{
    NSLog(@"homeBtnClicked");
    NSURL *url = [NSURL URLWithString:@"http://www.superiorbetng.com/MobilePlatform/home"];
    [[UIApplication sharedApplication] openURL:url];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self setUiWebView:nil];
}


- (void)loadWebView
{
    self.uiWebView.delegate = self;
    
    //  Load html from a local file for the about screen
    //NSString *aboutFilePath = [[NSBundle mainBundle] pathForResource:self.appAboutPageName ofType:@"html"];
    
    NSString *aboutFilePath = [[NSBundle mainBundle] pathForResource:@"termsNconditions" ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:aboutFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    
    NSString *aPath = [[NSBundle mainBundle] bundlePath];
    NSURL *anURL = [NSURL fileURLWithPath:aPath];
    [self.uiWebView loadHTMLString:htmlString baseURL:anURL];
}


//------------------------------------------------------------------------------
#pragma mark - UIWebViewDelegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    //  Opens the links within this UIWebView on a safari web browser
    
    BOOL retVal = NO;
    
    if ( inType == UIWebViewNavigationTypeLinkClicked )
    {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
    }
    else
    {
        retVal = YES;
    }
    
    return retVal;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Uncomment to have the double finger tap show the build number
//    UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTouches:)] autorelease];
//    gesture.numberOfTouchesRequired = 2;
//    [webView addGestureRecognizer:gesture];
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
