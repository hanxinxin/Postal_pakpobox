//
//  LPTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *left_Title;
@property (strong, nonatomic) IBOutlet UILabel *right_Title;

@end

NS_ASSUME_NONNULL_END
