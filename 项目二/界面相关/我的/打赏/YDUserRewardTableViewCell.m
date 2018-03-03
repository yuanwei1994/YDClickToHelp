//
//  YDUserRewardTableViewCell.m
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserRewardTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDURL.h"
#import "YDTimestampToDate.h"

@implementation YDUserRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRewardModel:(YDRewardModel *)rewardModel {
    _rewardModel = rewardModel;
    [self setSomeThing];
}

- (void)setSomeThing {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_rewardModel.to_avatar]];
    [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
    _user_nicenameLabel.text = _rewardModel.to_user_nicename;
    _add_timeLabel.text = _rewardModel.add_time;
    _wish_titleLabel.text = _rewardModel.wish_title;
    [_priceButton setTitle:[NSString stringWithFormat:@"已打赏%ld元",(long)[_rewardModel.price integerValue]] forState:UIControlStateNormal];
}

@end
