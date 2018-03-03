//
//  YDWillHotViewCell.m
//  ClickToHelp
//
//  Created by rimi on 16/11/21.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDWillHotViewCell.h"
#import "YDURL.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation YDWillHotViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWishModel:(YDWishModel *)wishModel {
    _wishModel = wishModel;
    [self setSomeThing];
}


-(void)setSomeThing{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_wishModel.avatar]] placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
    _nameLabel.text = _wishModel.user_nicename;
    _messageLabel.text = _wishModel.wish_title;
    _messageDescribeLabel.text = _wishModel.wish_desc;
    _hotLabel.text = _wishModel.wish_type;
    _hotLabel.textColor = [UIColor orangeColor];
    NSTimeInterval interval=[_wishModel.wish_add_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    _dataLabel.text = [NSString stringWithFormat:@"上线时间:%@",timeStr];
    _dataLabel.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
