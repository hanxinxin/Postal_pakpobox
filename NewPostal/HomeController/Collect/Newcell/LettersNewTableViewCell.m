//
//  LettersNewTableViewCell.m
//  NewPostal
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LettersNewTableViewCell.h"
#import "CellViewDown.h"

@implementation LettersNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)AddCellViewDown:(NSNumber * )letterCount Cell:(LettersNewTableViewCell*)cellA
{
    
    for (int i =0; i<([letterCount doubleValue]-2); i++) {
    
    static CGFloat frameBootom = 159.f;
    CellViewDown * CcellView = [[[NSBundle  mainBundle]  loadNibNamed:@"CellViewDown" owner:self options:nil]  lastObject];
        CcellView.frame = CGRectMake(cellA.cellView.left, frameBootom, cellA.cellView.width, cellA.cellView.height);
    frameBootom+=60;
    [self addSubview:CcellView];
    NSLog(@"frameBootom === %f ,,,, i= %d",frameBootom,i);
        NSLog(@"1===%f,2===%f,3===%f,4===%f",self.cellView.left, frameBootom, self.cellView.width, self.cellView.height);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


