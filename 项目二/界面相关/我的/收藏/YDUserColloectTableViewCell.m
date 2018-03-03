//
//  YDUserColloectTableViewCell.m
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserColloectTableViewCell.h"

#import "YDURL.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDTimestampToDate.h"


@implementation YDUserColloectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWishModel:(YDWishModel *)wishModel {
    _wishModel = wishModel;
    [self setSomeThing];
}

- (void)setSomeThing {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_wishModel.avatar]];
    [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
    _user_nicenameLabel.text = _wishModel.user_nicename;
    _wish_add_timeLabel.text = [YDTimestampToDate setDateStringWithTimestamp:_wishModel.wish_add_time];
    _wish_numLabel.text = _wishModel.wish_reward_num;
    _wish_reward_numImageView.image = [UIImage imageNamed:@"icon-热度"];
    
    _wish_titleLabel.text = _wishModel.wish_title;
    _wish_descLabel.text = _wishModel.wish_desc;
    
    _wish_reward_priceLabel.text = [NSString stringWithFormat:@"已打赏￥%ld",(long)[_wishModel.wish_reward_price integerValue]];
    _wish_reward_numLabel.text = [NSString stringWithFormat:@"打赏人数%ld",(long)[_wishModel.wish_reward_num integerValue]];
    _wish_priceLabel.text = [NSString stringWithFormat:@"求打赏￥%ld",(long)[_wishModel.wish_price integerValue]];

    
}


@end
