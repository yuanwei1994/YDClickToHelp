//
//  YDHomeFPTableViewCell.m
//  ClickToHelp
//
//  Created by rimi on 16/11/15.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeFPTableViewCell.h"



@implementation YDHomeFPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftImageView.layer.cornerRadius = 20;
    self.leftImageView.layer.masksToBounds = YES;
    self.MessageLabel.font = [UIFont systemFontOfSize:13];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
