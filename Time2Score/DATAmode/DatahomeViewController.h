//
//  DatahomeViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface DatahomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSTimer *myTimer;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollviewMain;

@property (nonatomic, strong) IBOutlet UIView *backview;
@property (nonatomic, strong) IBOutlet UILabel *lblphone;
@property (nonatomic, strong) IBOutlet UILabel *lblbalance;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) IBOutlet UIView *balanceview;

@property (nonatomic, strong) IBOutlet UITableView* tableListView;

@property (nonatomic, strong) NSString *matchcode;
@property (nonatomic, strong) NSString *slotHomeS;
@property (nonatomic, strong) NSString *slotAwayS;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *homekit;
@property (nonatomic, strong) NSString *awaykit;

@end

