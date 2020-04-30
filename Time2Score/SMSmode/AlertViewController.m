//
//  AlertViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

@synthesize scrollview, titleLbl, messageLbl, btnview;
@synthesize alerttitle, message, fromWhere;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 590.0)];
    [self.scrollview setBounces:FALSE];
    
    titleLbl.text = alerttitle;
    messageLbl.text = message;
    
}


-(IBAction)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    
    if ([fromWhere isEqualToString:@"LOGIN"])
    {
        [self performSegueWithIdentifier: @"SmshomeSegue" sender:self];
    }
    else if ([fromWhere isEqualToString:@"PLAY"])
    {
        [self performSegueWithIdentifier: @"UnwindFromPlayToFixturesSegue" sender:self];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
