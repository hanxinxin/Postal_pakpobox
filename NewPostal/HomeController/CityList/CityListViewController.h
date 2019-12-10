//
//  CityListViewController.h
//  NewPostal
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol CityListViewControllerDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)selectCity:(NSString*)cityStr;
@end
@interface CityListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *CityTableView;
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<CityListViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
