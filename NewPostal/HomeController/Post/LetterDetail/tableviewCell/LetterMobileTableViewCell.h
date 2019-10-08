//
//  LetterMobileTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol LetterMobileTableViewCellDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)push_btnTouch:(NSInteger)tag;

-(void)returnFieldStr:(NSString * )RightFieldStr TagStr:(NSInteger)tag;
@end


@interface LetterMobileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LeftTitle;
@property (strong, nonatomic) IBOutlet UIButton *centerB;

@property (strong, nonatomic) IBOutlet HQTextField *RightField;

// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<LetterMobileTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
