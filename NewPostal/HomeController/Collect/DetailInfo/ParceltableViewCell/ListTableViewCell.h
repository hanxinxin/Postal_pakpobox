//
//  ParcelTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *parcelLeft;
@property (strong, nonatomic) IBOutlet UILabel *compartmentLeft;
@property (strong, nonatomic) IBOutlet UILabel *ExpiryLeft;
@property (strong, nonatomic) IBOutlet UILabel *parcelRight;
@property (strong, nonatomic) IBOutlet UILabel *compartmentRight;
@property (strong, nonatomic) IBOutlet UILabel *ExpiryRight;

@end

NS_ASSUME_NONNULL_END
