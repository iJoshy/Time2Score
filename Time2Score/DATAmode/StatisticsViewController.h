//
//  StatisticsViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "HelperClass.h"

@interface StatisticsViewController : UIViewController <PNChartDelegate>

@property (nonatomic) PNPieChart * pieChart;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) IBOutlet UILabel *lblphone;
@property (nonatomic, strong) IBOutlet UILabel *lblbalance;

@property (nonatomic, strong) IBOutlet UILabel *lblnobet;
@property (nonatomic, strong) IBOutlet UILabel *lblhome;
@property (nonatomic, strong) IBOutlet UILabel *lblaway;
@property (nonatomic, strong) IBOutlet UILabel *lblmatch;

@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSDictionary *jsonResponse2;
@property (nonatomic, strong) IBOutlet UIView *leaguetableview;
@property (nonatomic, strong) IBOutlet UIView *balanceview;
@property (nonatomic, strong) IBOutlet UIView *backview;

@property (nonatomic, strong) IBOutlet UIButton *fBbutton;

@property (nonatomic, strong) NSMutableArray *clubstats;

@property (nonatomic, strong) NSString *matchcode;
@property (nonatomic, strong) NSString *slotHomeS;
@property (nonatomic, strong) NSString *slotAwayS;
@property (nonatomic, strong) NSString *country;

@end

