//
//  SelectCell.h
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *downLabel;

@end

NS_ASSUME_NONNULL_END
