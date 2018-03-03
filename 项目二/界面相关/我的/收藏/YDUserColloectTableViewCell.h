//
//  YDUserColloectTableViewCell.h
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDWishModel.h"

@interface YDUserColloectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wish_reward_numImageView;
@property (weak, nonatomic) IBOutlet UILabel *user_nicenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_add_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_numLabel;

@property (weak, nonatomic) IBOutlet UILabel *wish_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_descLabel;

@property (weak, nonatomic) IBOutlet UILabel *wish_reward_priceLabel;       //愿望目前的赏金
@property (weak, nonatomic) IBOutlet UILabel *wish_reward_numLabel;         //愿望目前的打赏人数
@property (weak, nonatomic) IBOutlet UILabel *wish_priceLabel;              //愿望的总金额


@property (nonatomic, strong) YDWishModel *wishModel;

@end
