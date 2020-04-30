//
//  HistoryViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface HistoryViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIImageView *columnView1;
@property (nonatomic, strong) IBOutlet UIImageView *columnView2;
@property (nonatomic, strong) IBOutlet UIImageView *columnView3;

@property (nonatomic, strong) IBOutlet UILabel *lblphone;
@property (nonatomic, strong) IBOutlet UILabel *lblbalance;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSDictionary *jsonResponse2;
@property (nonatomic, strong) IBOutlet UIView *balanceview;
@property (nonatomic, strong) IBOutlet UIView *backview;

@property (nonatomic, strong) IBOutlet UILabel *gaminglbl;
@property (nonatomic, strong) IBOutlet UILabel *winninglbl;
@property (nonatomic, strong) IBOutlet UILabel *promolbl;

@end

