//
//  DInfoTableViewCell.m
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "DInfoTableViewCell.h"

@implementation DInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.EditBtn setImage:[UIImage imageNamed:@"icon_edit"] forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Edit_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(push_EditTouch:)]) {
        [self.delegate push_EditTouch:self.tag]; // 回调代理
    }
}

@end
