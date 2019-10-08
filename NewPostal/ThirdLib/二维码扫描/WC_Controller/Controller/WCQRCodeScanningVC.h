//
//  WCQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol WCQRCodeScanningDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)returnWCQRStr:(NSString*)WCQRStr;
@end
@interface WCQRCodeScanningVC : UIViewController

@property (assign,nonatomic)NSInteger tag_int;  //// 1是 parcel 2 是packets
@property (assign,nonatomic)NSString * ordersId;  ////有ID要传，没有ID则不用传
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<WCQRCodeScanningDelegate> delegate;
@end
