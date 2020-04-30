//
//  MatchListCell.h
//  Time2Score
//
//  Created by Joshua Balogun on 7/11/16.
//  Copyright © 2016 Superior Games Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* dateLabel;
@property (nonatomic, strong) IBOutlet UILabel* timeLabel;
@property (nonatomic, strong) IBOutlet UILabel* homeLabel;
@property (nonatomic, strong) IBOutlet UILabel* awayLabel;
@property (nonatomic, strong) IBOutlet UILabel* homeScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel* awayScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel* vsLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) IBOutlet UIImageView* homeJersey;
@property (nonatomic, strong) IBOutlet UIImageView* awayJersey;

@end
