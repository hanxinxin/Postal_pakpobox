//
//  QRTableViewCell.m
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QRTableViewCell.h"

@implementation QRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Click_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(push_btnTouch:)]) {
        [self.delegate push_btnTouch:0]; // 回调代理
    }
}



@end
