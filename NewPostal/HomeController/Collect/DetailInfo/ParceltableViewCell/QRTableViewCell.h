//
//  QRTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol QRTableViewCellDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)push_btnTouch:(NSInteger)tag;
@end



@interface QRTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topTitle;
@property (strong, nonatomic) IBOutlet UIImageView *QRImage;
@property (strong, nonatomic) IBOutlet UILabel *PCodeLabel;

@property (strong, nonatomic) IBOutlet UIButton *ClickBtn;
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<QRTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
