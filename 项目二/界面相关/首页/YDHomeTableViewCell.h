//
//  YDHomeTableViewCell.h
//  ClickToHelp
//
//  Created by rimi on 16/11/5.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDWishModel.h"

@interface YDHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *user_nicenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_reward_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *wish_reward_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *wish_add_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *wish_numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wish_reward_num_imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic,strong) YDWishModel * wishModel;

-(void)setSomeThing;
@end
