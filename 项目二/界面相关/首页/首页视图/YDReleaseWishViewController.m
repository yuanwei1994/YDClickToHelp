//
//  YDReleaseWishViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/21.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDReleaseWishViewController.h"

@interface YDReleaseWishViewController ()
@property (nonatomic,strong) UITextField * titleField;
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIView *cutView;
@end

@implementation YDReleaseWishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setSomeThing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarBtn)];
    //
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleField];
    [self.view addSubview:self.cutView];
    [self.view addSubview:self.textView];
}

#pragma mark -- BtnAction

-(void)onRightBarBtn{
    YDLog(@"123");
}

#pragma mark -- getter
-(UITextField *)titleField{
    if (!_titleField) {
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64, SCREEN_SIZE.width-40, 30)];
        _titleField.placeholder = @"标题(用一句话描述你的愿望目的)";
    }
    return _titleField;
}

-(UIView *)cutView{
    if (!_cutView) {
        _cutView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleField.frame), CGRectGetMaxY(_titleField.frame), SCREEN_SIZE.width-40, 1)];
        _cutView.backgroundColor = APP_MAIN_COLOR;
    }
    return _cutView;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleField.frame), CGRectGetMaxY(_cutView.frame), SCREEN_SIZE.width-40, 250*SCREEN_HEIGHT_SCALE)];
        _textView.backgroundColor = [UIColor whiteColor];
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleField.frame), CGRectGetMaxY(_textView.frame), SCREEN_SIZE.width - 40, 1)];
        bottomView.backgroundColor = APP_MAIN_COLOR;
        [self.view addSubview:bottomView];
    }
    return _textView;
}

@end
