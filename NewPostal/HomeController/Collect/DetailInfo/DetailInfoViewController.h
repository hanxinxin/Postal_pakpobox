//
//  DetailInfoViewController.h
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *ZtableView;
@property (nonatomic,strong) ParcelMode * modeA;
@end

NS_ASSUME_NONNULL_END
