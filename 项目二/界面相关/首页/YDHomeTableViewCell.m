//
//  YDHomeTableViewCell.m
//  ClickToHelp
//
//  Created by rimi on 16/11/5.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeTableViewCell.h"
#import "YDURL.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YDHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImageView.layer.cornerRadius = 30;
    _avatarImageView.layer.masksToBounds = YES;
}

- (void)setWishModel:(YDWishModel *)wishModel {
    _wishModel = wishModel;
    [self setSomeThing];
}

-(void)setSomeThing{
    //没有设置默认图片的
//    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_wishModel.avatar]]];
    //设置默认图片
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_wishModel.avatar]] placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
    _user_nicenameLabel.text = _wishModel.user_nicename;
    _wish_titleLabel.text = _wishModel.wish_title;
    _wish_reward_priceLabel.text = [NSString stringWithFormat:@"已打赏￥%ld",(long)[_wishModel.wish_reward_price integerValue]];
    _wish_reward_numLabel.text = [NSString stringWithFormat:@"打赏人数%ld",(long)[_wishModel.wish_reward_num integerValue]];
    _wish_priceLabel.text = [NSString stringWithFormat:@"求打赏￥%ld",(long)[_wishModel.wish_price integerValue]];
    //时间戳转换为时间
    NSTimeInterval interval=[_wishModel.wish_add_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    _wish_add_timeLabel.text = timeStr;
    _wish_numLabel.text = _wishModel.wish_reward_num;
    _wish_reward_num_imageView.image = [UIImage imageNamed:@"icon-热度"];
    _progressBar.progress = [_wishModel.wish_reward_price floatValue]/[_wishModel.wish_price floatValue];
    
    _progressLabel.text = [NSString stringWithFormat:@"%0.f%%",([_wishModel.wish_reward_price floatValue]/[_wishModel.wish_price floatValue])*100];
}




@end
