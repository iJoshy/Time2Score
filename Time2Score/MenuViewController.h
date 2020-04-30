//
//  MenuViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface MenuViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIView *backview;
@property (nonatomic, strong) IBOutlet UIView *blockview;
@property (nonatomic, strong) IBOutlet UIImageView *exitview;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, strong) NSString *screenType;

@end

