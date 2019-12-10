//
//  ZDYQRCodeScanningVC.h
//  NewPostal
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol ZDYQRCodeScanningDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)returnWCQRStr:(NSString*)WCQRStr;
@end
@interface ZDYQRCodeScanningVC : UIViewController

@property (assign,nonatomic)NSInteger tag_int;  //// 1是 parcel 2 是packets
@property (assign,nonatomic)NSString * ordersId;  ////有ID要传，没有ID则不用传
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<ZDYQRCodeScanningDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
