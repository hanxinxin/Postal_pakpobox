//
//  PostViewController.h
//  NewPostal
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *Tableview;
@property (strong, nonatomic) IBOutlet UIButton *AddNew;
@property (strong, nonatomic) IBOutlet UIView *NilVIew;
@property (strong, nonatomic) IBOutlet UIImageView *imageN;
@property (strong, nonatomic) IBOutlet UILabel *LabelN;

@end

NS_ASSUME_NONNULL_END
