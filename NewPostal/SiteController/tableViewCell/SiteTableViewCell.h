//
//  SiteTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SiteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *DownLabel;
@property (strong, nonatomic) IBOutlet UIButton *KMbtn;
@property (strong, nonatomic) IBOutlet UILabel *KMLabel;

@end

NS_ASSUME_NONNULL_END
