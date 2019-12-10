//
//  LettersNewTableViewCell.h
//  NewPostal
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LettersNewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleDownLabel;
@property (strong, nonatomic) IBOutlet UILabel *ItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *ItemsCoutLabel;



@property (strong, nonatomic) IBOutlet UILabel *xianLabel;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *cellTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellDownLabel;

-(void)AddCellViewDown:(NSNumber * )letterCount Cell:(LettersNewTableViewCell*)cellA;

@end

//@interface CellViewDown : UIView
//@property (strong, nonatomic) IBOutlet UILabel *cellTopLabelA;
//@property (strong, nonatomic) IBOutlet UILabel *cellDownLabelA;
//@end




NS_ASSUME_NONNULL_END
