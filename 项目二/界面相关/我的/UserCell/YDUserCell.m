//
//  YDUserCell.m
//  ClickToHelp
//
//  Created by Candy on 16/11/6.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserCell.h"

@implementation YDUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setSomeThing];
}

-(void)setSomeThing{
    _cellTitle.text = _title;
    _cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"个人中心-%@",_title]];
    _rightImageView.image = [UIImage imageNamed:@"个人中心-right"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

}

@end
