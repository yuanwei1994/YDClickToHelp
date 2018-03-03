//
//  YDSearchImageView.m
//  ClickToHelp
//
//  Created by rimi on 16/11/4.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDSearchImageView.h"




@implementation YDSearchImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSomeThing];
    }
    return self;
}

-(void)setSomeThing{
    self.frame = CGRectMake(0, 0, 300, 30);
    self.image = [UIImage imageNamed:@"搜索框"];
    self.userInteractionEnabled = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"放大镜"]];
    leftImage.frame = CGRectMake(5, 5, 20, 20);
    [view addSubview:leftImage];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
    label.text = @"项目、用户";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UITapGestureRecognizer * imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onimageViewTap)];
    [self addSubview:view];
    [self addGestureRecognizer:imageViewTap];
}

-(void)onimageViewTap{
    [_delegate pushViewController];
}


@end
