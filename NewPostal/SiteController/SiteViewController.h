//
//  SiteViewController.h
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SiteViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UIButton *centralBtn;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) IBOutlet UITableView *DownTableView;

@end

NS_ASSUME_NONNULL_END
