//
//  YDBaseViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/4.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDBaseViewController.h"


@interface YDBaseViewController ()

@end

@implementation YDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, 20, 20);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = backView.frame;
    [btn setImage:[UIImage imageNamed:@"个人中心-left"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBackItem) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
}

-(void)onBackItem{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
