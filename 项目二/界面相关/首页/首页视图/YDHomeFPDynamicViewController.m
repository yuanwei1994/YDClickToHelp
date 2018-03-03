//
//  YDHomeFPDynamicViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/15.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeFPDynamicViewController.h"

#import "YDPieView.h"
#import "YDConfig.h"
#import "YDHomeRequest.h"
@interface YDHomeFPDynamicViewController ()
@property (nonatomic,strong) UILabel * redPacketsLabel;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat sum;
@property (nonatomic,strong) UILabel * bigLabel;
@property (nonatomic,strong) UILabel * smallLabel;
@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic, strong) YDPieView *pieView;
@end

@implementation YDHomeFPDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日福包动态";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [YDHomeRequest starPostRequest:HOME_DYNAMIC_URL parameters:nil comletionHandler:^(YDResponse *response) {
        NSMutableString  * redstr = [[NSString stringWithFormat:@"红包总数:%@个",response.resultVaule[@"today"]] mutableCopy];
        self.redPacketsLabel.attributedText = [self setRedPacketsAttributedStr:redstr];
        NSMutableString * bigstr = [[NSString stringWithFormat:@"大额:%@",response.resultVaule[@"de"]] mutableCopy];
        self.bigLabel.attributedText = [self setBigOrSmallAttributedStr:bigstr];
        NSMutableString * smallstr = [[NSString stringWithFormat:@"小额:%@",response.resultVaule[@"xe"]] mutableCopy];
        self.smallLabel.attributedText = [self setBigOrSmallAttributedStr:smallstr];
        [self.webView loadHTMLString:response.resultVaule[@"desc"] baseURL:nil];
        _max = [response.resultVaule[@"de"] floatValue]; // / sum;
        _min = [response.resultVaule[@"xe"] floatValue]; /// sum;
        _sum = [response.resultVaule[@"today"] floatValue];
        //重新赋值
        NSMutableArray * pieModel = [NSMutableArray array];
        NSArray * Array = @[APP_MAIN_COLOR,COLOR_RGB(250, 142, 28, 1)];
        NSArray * numArray = @[@(_min),@(_max)];
        for (int i = 0; i<2; i++) {
            YDPieModel * model = [[YDPieModel alloc] initWithValue:[numArray[i] floatValue] color:Array[i] sum:_sum];
            [pieModel addObject:model];
        }
        self.pieView.pieModels = pieModel;
        [self.pieView reloadDatas];
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setSomeThing{
    NSMutableArray * pieModel = [NSMutableArray array];
    NSArray * Array = @[APP_MAIN_COLOR,COLOR_RGB(250, 142, 28, 1)];
    NSArray * numArray = @[@(_min),@(_max)];
    for (int i = 0; i<2; i++) {
        YDPieModel * model = [[YDPieModel alloc] initWithValue:[numArray[i] floatValue] color:Array[i] sum:_sum];
        [pieModel addObject:model];
    }
    _pieView = [[YDPieView alloc] initWithFrame:CGRectMake(0, 0, 300*SCREEN_WIDTH_SCALE, 160*SCREEN_WIDTH_SCALE) pieModels:pieModel offset:10];
    _pieView.center = CGPointMake(self.view.center.x, 220*SCREEN_WIDTH_SCALE);
    UIView * centerview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.smallLabel.frame)+10, SCREEN_SIZE.width, 50)];
    //centerview.backgroundColor = [UIColor grayColor];
    
    UIView * cutView = [[UIView alloc] init];
    cutView.bounds = CGRectMake(0, 0, SCREEN_SIZE.width*0.9, 1);
    cutView.center = CGPointMake(centerview.center.x, 0);
    cutView.backgroundColor = COLOR_RGB(211, 216, 205, 1);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(centerview.frame) - 21, 80, 21)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"福包介绍";
    
    [centerview addSubview:label];
    [centerview addSubview:cutView];
    [self.view addSubview:centerview];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.redPacketsLabel];
    [self.view addSubview:self.bigLabel];
    [self.view addSubview:self.smallLabel];
    [self.view addSubview:_pieView];
    

}

-(NSMutableAttributedString*)setRedPacketsAttributedStr:(NSMutableString*)str{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]
                                                initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:APP_MAIN_COLOR range:NSMakeRange(5, 3)];
    return AttributedStr;
}

-(NSMutableAttributedString*)setBigOrSmallAttributedStr:(NSMutableString*)str{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]
                                                initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:APP_MAIN_COLOR range:NSMakeRange(3, 3)];
    return AttributedStr;
}

-(UILabel *)redPacketsLabel{
    if (!_redPacketsLabel) {
        _redPacketsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 94, 150, 30)];
    }
    return _redPacketsLabel;
}

-(UILabel *)bigLabel{
    if (!_bigLabel) {
        _bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pieView.frame), CGRectGetMaxY(_pieView.frame), CGRectGetWidth(_pieView.frame)/2, 30)];
        _bigLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bigLabel;
}

-(UILabel *)smallLabel{
    if (!_smallLabel) {
        _smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bigLabel.frame), CGRectGetMaxY(_pieView.frame), CGRectGetWidth(_pieView.frame)/2, 30)];
        _smallLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _smallLabel;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.smallLabel.frame)+80, SCREEN_SIZE.width, 300)];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

@end
