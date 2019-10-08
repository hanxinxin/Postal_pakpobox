//
//  LetterNameTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol LetterNameTableViewCellDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)AddressInfo:(NSInteger)tag;
-(void)returnRightFieldName:(NSString * )RightFieldStr TagStr:(NSInteger)tag;
@end
@interface LetterNameTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LeftTitle;
@property (strong, nonatomic) IBOutlet HQTextField *RightField;
@property (strong, nonatomic) IBOutlet UIButton *phoneImage;
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<LetterNameTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
