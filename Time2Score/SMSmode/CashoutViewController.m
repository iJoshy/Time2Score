//
//  CashoutViewController.m
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import "CashoutViewController.h"

@interface CashoutViewController ()

@end

@implementation CashoutViewController

@synthesize scrollview, txtview, btnview, alertView, gateways;
@synthesize jsonResponse, lblphone, balanceview, screenType;
@synthesize lblbalance, dropdown, dialogMessage, tableListView, lblmsg;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    
    [super viewDidLoad];
    
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
    
    screenType = [[NSUserDefaults standardUserDefaults] stringForKey:@"SCREENTYPE"];
    
    if ([screenType isEqualToString:@"DATA"])
    {
        lblphone.text = [NSString stringWithFormat:@"No: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"PHONE"]];
        [self getBalance];
        
        dropdown.layer.sublayerTransform = CATransform3DMakeTranslation(20.0f, 0.0f, 0.0f);
        
        UIImageView *usernameicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down.png"]];
        usernameicon.frame = CGRectMake(0.0, 0.0, usernameicon.image.size.width+60.0, usernameicon.image.size.height);
        usernameicon.contentMode = UIViewContentModeCenter;
        self.dropdown.rightView = usernameicon;
        self.dropdown.rightViewMode = UITextFieldViewModeAlways;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
        [self.dropdown.superview addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
        [self.balanceview.superview addGestureRecognizer:tapGesture1];
        
    }
    else if ([screenType isEqualToString:@"SMS"])
    {
        UIButton *balanceView = (UIButton*)[self.view   viewWithTag:300];
        [balanceView removeFromSuperview];
        
        [dropdown removeFromSuperview];
    }
    
}


- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(self.dropdown.frame, point))
        {
            // Here we need to pass a full frame
            alertView = [[CustomIOSAlertView alloc] init];
            
            // Add some custom content to the alert view
            [alertView setContainerView:[self createDemoView]];
            
            // Modify the parameters
            [alertView setButtonTitles:nil];
            [alertView setDelegate:self];
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
        }
        else if (CGRectContainsPoint(self.balanceview.frame, point))
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HISTORY" object:nil userInfo:nil];
        }
        
    }
    
}


- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    tableListView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    [tableListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableListView setDelegate:self];
    [tableListView setDataSource:self];
    
    gateways = [[NSMutableArray alloc] initWithObjects:@"ReadyCash", nil];
    
    [self.tableListView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tableListView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [demoView addSubview:tableListView];
    lblmsg.text = @"To use Readycash you must have an account. To register dial *732# or download the readycash mobile app from the google play store";
    
    return demoView;
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)outalertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[outalertView tag]);
    [outalertView close];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.gateways count];
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tap to select channel";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell= @"Menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: Cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = [self.gateways objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:13.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@" name :: %@", cell.textLabel.text);
    
    dropdown.text = cell.textLabel.text;
    [alertView close];
}


-(void)getBalance
{
    lblbalance.text = [NSString stringWithFormat:@"₦ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"WINNINGSBAL"]];
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
        if ([screenType isEqualToString:@"DATA"])
        {
            [self callService];
        }
        else if ([screenType isEqualToString:@"SMS"])
        {
            NSString *file = [NSString stringWithFormat:@"CASHOUT %@",txtview.text];
            [self showSMS:file];
        }
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^([0-9]+)?$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    if (numberOfMatches == 0)
        return NO;
    
    return YES;
    
}




-(void)callService
{
    
    NSString *amount = txtview.text;
    NSString *gatewayS = dropdown.text;
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    
    
    if (amount.length != 0)
    {
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([amount rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            [SVProgressHUD showWithStatus:@"Please wait ..."];
            jsonResponse  = nil;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                           {
                               WebServiceCall *ws = [[WebServiceCall alloc] init];
                               
                               NSDictionary *response = [ws cashout:token :gatewayS :amount];
                               
                               [self setJsonResponse:response];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [SVProgressHUD dismiss];
                                   [self processInitData];
                               });
                           });
        }
        else
        {
            [self showSelfDismissingAlertViewWithMessage:@"Kindly type in a valid amount"];
        }
        
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:@"Amount cannot be 0"];
    }
    
    
}


-(void)processInitData
{
    
    NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *message = [dataContent objectForKey:@"message"];
    NSString *success = [dataContent objectForKey:@"success"];
    NSString *status = [dataContent objectForKey:@"status"];
    
    NSLog(@"message ::: %@",message);
    NSLog(@"success ::: %@",success);
    NSLog(@"status ::: %@",status);
    
    dialogMessage = message;
    success = [NSString stringWithFormat:@"%@",success];
    status = [NSString stringWithFormat:@"%@",status];
    
    if ([success isEqualToString:@"1"] && [status isEqualToString:@"3"])
    {
        
        NSString *winningsBal = [dataContent objectForKey:@"winningsBal"];
        NSLog(@"winningsBal ::: %@",winningsBal);
        
        [[NSUserDefaults standardUserDefaults] setObject:winningsBal forKey:@"WINNINGSBAL"];
        
        [self performSegueWithIdentifier: @"CashoutAlertSegue" sender:self];
        [self getBalance];
        
    }
    else
    {
        [self showSelfDismissingAlertViewWithMessage:message];
    }
    
    
    NSString *status_code = [NSString stringWithFormat:@"%@",[dataContent objectForKey:@"status_code"]];
    if ([status_code isEqualToString:@"500"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil userInfo:nil];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"CashoutAlertSegue"])
    {
        // Get reference to the destination view controller
        AlertDialogViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setFromWhere:@"CASHOUT"];
        [vc setAlerttitle:@"Cashout"];
        [vc setMessage:dialogMessage];
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
    NSString *from = [[NSUserDefaults standardUserDefaults] stringForKey:@"FROM"];
    if( [from isEqualToString:@"HOME"] )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if( [from isEqualToString:@"MENU"] )
    {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
