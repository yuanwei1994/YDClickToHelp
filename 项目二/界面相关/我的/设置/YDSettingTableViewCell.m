//
//  YDSettingTableViewCell.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDSettingTableViewCell.h"

@implementation YDSettingTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

- (void)setLeftLabelString:(NSString *)leftLabelString {
    _leftLabelString = leftLabelString;
    _leftLabel.text = _leftLabelString;
}
- (void)setTextFieldString:(NSString *)textFieldString {
    _textFieldString = textFieldString;
    _centerTextField.text = _textFieldString;
}
- (void)setRightImageName:(NSString *)rightImageName {
    _rightImageName = rightImageName;
    _rightImageView.image = [UIImage imageNamed:_rightImageName];
}



@end
