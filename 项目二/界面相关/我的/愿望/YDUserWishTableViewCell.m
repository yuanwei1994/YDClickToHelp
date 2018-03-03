//
//  YDUserWishTableViewCell.m
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserWishTableViewCell.h"
#import "YDTimestampToDate.h"

@implementation YDUserWishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setWishModel:(YDWishModel *)wishModel {
    _wishModel = wishModel;
    [self setSomeThing];
    
}

- (void)setSomeThing {
    _wishTitleLabel.text = _wishModel.wish_title;
    NSString *dateStr = [YDTimestampToDate setDateStringWithTimestamp:_wishModel.wish_add_time]; //将时间戳转换成日期
    _wishAddTimeabel.text = dateStr;
    _rewardNumImageView.image = [UIImage imageNamed:@"icon-热度"];
    _rewardNumLabel.text = _wishModel.wish_reward_num;
    _progressBar.progress = [_wishModel.wish_reward_price floatValue]/[_wishModel.wish_price floatValue];
    _progressLabel.text = [NSString stringWithFormat:@"%0.f%%",([_wishModel.wish_reward_price floatValue]/[_wishModel.wish_price floatValue])*100];
    _wishRewardPriceLabel.text = [NSString stringWithFormat:@"已打赏￥%ld",(long)[_wishModel.wish_reward_price integerValue]];
    _wishRewardNumLabel.text = [NSString stringWithFormat:@"打赏人数%ld",(long)[_wishModel.wish_reward_num integerValue]];
    _wishPriceLabel.text = [NSString stringWithFormat:@"求打赏￥%ld",(long)[_wishModel.wish_price integerValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

}

@end
