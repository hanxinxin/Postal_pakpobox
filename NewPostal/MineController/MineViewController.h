//
//  MineViewController.h
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *TopView;
@property (strong, nonatomic) IBOutlet UIButton *HeadImage;
@property (strong, nonatomic) IBOutlet UILabel *HeadTitle;
@property (strong, nonatomic) IBOutlet UITableView *DownTableView;

@end

NS_ASSUME_NONNULL_END
