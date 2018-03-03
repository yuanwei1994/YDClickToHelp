//
//  YDWillHotViewCell.h
//  ClickToHelp
//
//  Created by rimi on 16/11/21.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDWishModel.h"
@interface YDWillHotViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@property (nonatomic,strong) YDWishModel * wishModel;
@end
