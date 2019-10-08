//
//  ClassFrame.h
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassFrame : NSObject

/**
 获取高度

 */
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

/**
 获取宽度

 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font ;
@end

NS_ASSUME_NONNULL_END
