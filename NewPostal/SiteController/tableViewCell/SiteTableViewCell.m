//
//  SiteTableViewCell.m
//  NewPostal
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SiteTableViewCell.h"

@implementation SiteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.KMbtn setBackgroundImage:[UIImage imageNamed:@"icon_in"] forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
