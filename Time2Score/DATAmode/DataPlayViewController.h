//
//  DataPlayViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface DataPlayViewController : UIViewController
{
    int pos;
    int slots;
    NSTimer *myTimer;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollviewMain;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UILabel *slotsPricelbl;
@property (nonatomic, strong) IBOutlet UIButton *btnview;

@property (nonatomic, strong) IBOutlet UILabel *lblbalance;
@property (nonatomic, strong) IBOutlet UILabel *lblhomescore;
@property (nonatomic, strong) IBOutlet UILabel *lblawayscore;

@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSDictionary *jsonResponse2;
@property (nonatomic, strong) NSDictionary *jsonResponse3;
@property (nonatomic, strong) IBOutlet UIView *balanceview;
@property (nonatomic, strong) IBOutlet UIView *statsview;

@property (nonatomic, strong) IBOutlet UIImageView *homekitImg;
@property (nonatomic, strong) IBOutlet UIImageView *awaykitImg;

@property (nonatomic, strong) NSString *matchcode;
@property (nonatomic, strong) NSString *slotHomeS;
@property (nonatomic, strong) NSString *slotAwayS;
@property (nonatomic, strong) NSString *homekit;
@property (nonatomic, strong) NSString *awaykit;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *dialogslots;

@property (nonatomic, strong) NSMutableArray *slotBtn;
@property (nonatomic, strong) NSMutableArray *slotHome;
@property (nonatomic, strong) NSMutableArray *slotAway;

@property (nonatomic, strong) IBOutlet UITextView *slotHomeTxt;
@property (nonatomic, strong) IBOutlet UITextView *slotAwayTxt;

@property (nonatomic, strong) IBOutlet UILabel *slotHomeLbl;
@property (nonatomic, strong) IBOutlet UILabel *slotAwayLbl;

@end

