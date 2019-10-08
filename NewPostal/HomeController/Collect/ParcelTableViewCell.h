//
//  ParcelTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParcelTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *parcelTitle;
@property (strong, nonatomic) IBOutlet UILabel *parcelText;
@property (strong, nonatomic) IBOutlet UILabel *locationTitle;
@property (strong, nonatomic) IBOutlet UILabel *locationText;
@property (strong, nonatomic) IBOutlet UILabel *FenGeLabel;
@property (strong, nonatomic) IBOutlet UIButton *QJBtn;

@end

NS_ASSUME_NONNULL_END
