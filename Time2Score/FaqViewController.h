//
//  FaqViewController.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#include "HelperClass.h"

@interface FaqViewController : UIViewController <UITextFieldDelegate>
{
    AccordionView *accordion;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *tempArray;

@property (nonatomic, strong) IBOutlet UILabel* dateLbl;
@property (nonatomic, strong) IBOutlet UILabel* narrationLbl;
@property (nonatomic, strong) IBOutlet UILabel* amountLbl;
@property (nonatomic, strong) NSNumberFormatter *nf;


- (IBAction)showLeftMenuPressed:(id)sender;

@end

