//
//  JZTouchIDManager.h
//  SynjonesPay
//
//  Created by 樊建政 on 2018/1/5.
//  Copyright © 2018年 Boole. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JZTouchID    [JZTouchIDManager shareManager]

// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol JZTouchIDManagerDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
/**
 返回是否验证成功

 @param touch_YN 0:是不成功 1:成功 5:是没有设置ID 10:touch不可用
 */
-(void)TouchVerify:(NSInteger)touch_YN; //////
@end

@interface JZTouchIDManager : NSObject
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<JZTouchIDManagerDelegate> delegate;

+ (instancetype)shareManager;

- (BOOL)openTouchId:(BOOL)config;


@end
