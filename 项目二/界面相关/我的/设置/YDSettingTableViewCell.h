//
//  YDSettingTableViewCell.h
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *centerTextField;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, strong) NSString *leftLabelString;
@property (nonatomic, strong) NSString *textFieldString;
@property (nonatomic, strong) NSString *rightImageName;


@end
