//
//  PacketsTableViewCell.m
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PacketsTableViewCell.h"

@implementation PacketsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.QJBtn setImage:[UIImage imageNamed:@"icon_next"] forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
