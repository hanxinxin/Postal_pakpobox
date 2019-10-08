//
//  PostTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *letterNo;
@property (strong, nonatomic) IBOutlet UILabel *NumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *PopButton;

@end

NS_ASSUME_NONNULL_END
