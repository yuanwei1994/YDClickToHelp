//
//  YDResetPassTableViewCell.h
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDResetPassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel        *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField    *textField;

@property (nonatomic, copy) NSString                *leftLabelString;
@property (nonatomic, copy) NSString                *textFieldString;
@property (nonatomic, copy) NSString                *textFieldPlaceholderString;



@end
