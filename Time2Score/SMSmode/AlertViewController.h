//
//  AlertViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface AlertViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *messageLbl;
@property (nonatomic, strong) IBOutlet UIButton *btnview;
@property (nonatomic, strong) NSString *fromWhere;
@property (nonatomic, strong) NSString *alerttitle;
@property (nonatomic, strong) NSString *message;

@end

