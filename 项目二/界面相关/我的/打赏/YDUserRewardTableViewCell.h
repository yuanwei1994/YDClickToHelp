//
//  YDUserRewardTableViewCell.h
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDRewardModel.h"


@interface YDUserRewardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;          //打赏用户的头像
@property (weak, nonatomic) IBOutlet UILabel *user_nicenameLabel;           //打赏用户的昵称
@property (weak, nonatomic) IBOutlet UILabel *add_timeLabel;                //打赏的时间
@property (weak, nonatomic) IBOutlet UILabel *wish_titleLabel;              //愿望标题
@property (weak, nonatomic) IBOutlet UIButton *priceButton;                 //打赏的金额



@property (nonatomic, strong) YDRewardModel    *rewardModel;                    //愿望模型


@end
