//
//  MatchListCell.m
//  mapper
//
//  Created by Tope on 25/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchListCell.h"

@implementation MatchListCell

@synthesize dateLabel, timeLabel, homeLabel, awayLabel, homeScoreLabel;
@synthesize vsLabel, statusLabel, homeJersey, awayJersey, awayScoreLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
