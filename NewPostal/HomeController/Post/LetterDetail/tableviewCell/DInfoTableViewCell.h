//
//  DInfoTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol DInfoTableViewCellDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)push_EditTouch:(NSInteger)tag;

@end
@interface DInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TopL_title;
@property (strong, nonatomic) IBOutlet UILabel *TopC_title;
@property (strong, nonatomic) IBOutlet UILabel *Down_Title;
@property (strong, nonatomic) IBOutlet UIButton *EditBtn;
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<DInfoTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
