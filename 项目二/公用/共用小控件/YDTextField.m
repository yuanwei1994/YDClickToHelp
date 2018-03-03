//
//  YDTextField.m
//  ClickToHelp
//
//  Created by rimi on 16/11/14.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDTextField.h"

@implementation YDTextField

-(void)addyuan{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]
                                                initWithString:@"| 元"];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14]range:NSMakeRange(0, 2)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(0, 1)];
    label.attributedText = AttributedStr;
    label.font = [UIFont systemFontOfSize:15];
    self.rightView = label;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
