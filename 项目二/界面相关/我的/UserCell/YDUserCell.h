//
//  YDUserCell.h
//  ClickToHelp
//
//  Created by Candy on 16/11/6.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;        //左边图片
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;            //标题
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;   //右边图片

@property (nonatomic, copy) NSString *title;

-(void)setSomeThing;

@end
