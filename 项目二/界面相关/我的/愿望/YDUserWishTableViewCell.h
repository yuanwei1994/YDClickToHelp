//
//  YDUserWishTableViewCell.h
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDWishModel.h"

@interface YDUserWishTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wishTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wishAddTimeabel;
@property (weak, nonatomic) IBOutlet UIImageView *rewardNumImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardNumLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *wishRewardPriceLabel;         //已打赏
@property (weak, nonatomic) IBOutlet UILabel *wishRewardNumLabel;           //打赏人数
@property (weak, nonatomic) IBOutlet UILabel *wishPriceLabel;               //求打赏

@property (nonatomic, strong) YDWishModel    *wishModel;                    //愿望模型

@end
