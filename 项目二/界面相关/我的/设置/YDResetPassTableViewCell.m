//
//  YDResetPassTableViewCell.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDResetPassTableViewCell.h"

@implementation YDResetPassTableViewCell

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
    _textField.text = _textFieldString;
}
- (void)setTextFieldPlaceholderString:(NSString *)textFieldPlaceholderString {
    _textFieldPlaceholderString = textFieldPlaceholderString;
    _textField.placeholder = _textFieldPlaceholderString;
}

@end
