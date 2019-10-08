//
//  TextTableViewCell.m
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TextTableViewCell.h"
@interface TextTableViewCell ()<UITextFieldDelegate>
{

}
@end
@implementation TextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _RightField.delegate = self;
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_RightField resignFirstResponder];
        return NO;
    }
    return YES;
}

///键盘消失事件

- (void) keyboardWillHide:(NSNotification *)notify {
    //    NSLog(@"键盘将要消失 %@",self.Right_textField.text);
    // 键盘动画时间
    
    if ([self.delegate respondsToSelector:@selector(returnRightField:TagStr:)]) {
        [self.delegate returnRightField:self.RightField.text TagStr:self.tag]; // 回调代理
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(returnRightField:TagStr:)]) {
        [self.delegate returnRightField:self.RightField.text TagStr:self.tag]; // 回调代理
    }
    return YES;
}
@end
