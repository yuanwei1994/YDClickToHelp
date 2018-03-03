//
//  YDHomeSpareViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeSpareViewController.h"
#import "YDHomeSpareView.h"
#import "YDBaseRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "YDConfig.h"
#import "YDTextField.h"
#import "YDAlertViewController.h"

@interface YDHomeSpareViewController ()<YDHomeSpareViewDelegate, WXApiDelegate>
@property (nonatomic,strong) UIView * headView;
@property (nonatomic,strong) UIView * centerView;
@property (nonatomic,strong) UIButton * button;
@property (nonatomic,strong) YDTextField * textField;
@property (nonatomic,strong) YDHomeSpareView * selectedView;

@end

@implementation YDHomeSpareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setSomeThing{
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    self.navigationItem.title = @"打赏";
    [self.view addSubview:self.headView];
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.button];
}

//-(void)onViewTap:(UITapGestureRecognizer *)gesture{
//    UIView * sender = gesture.view;
//    if (sender.tag == 100) {
//        [sender viewWithTag:200].hidden = ![sender viewWithTag:200].hidden;
//    }
//    
//}

#pragma mark- YDHomeSpareViewDelegate

- (void)homeSpareViewDidPressed:(YDHomeSpareView *)homeSpareView {
    if (self.selectedView == homeSpareView) {
        return;
    }
    self.selectedView.selected = NO;
    homeSpareView.selected = YES;
    self.selectedView = homeSpareView;
}


#pragma mark - Action
-(void)onThePayBtn {
    //if (self.selectedView.tag - 100 == 1) {
    NSDictionary *parameters = @{@"wish_id":@([self.wishModel.wish_id intValue]),
                                     @"pay_type":@(self.selectedView.tag - 100),
                                     @"bonus":self.textField.text};
    NSInteger flag = self.selectedView.tag - 100;
    [YDBaseRequest starPostRequest:REWARD_WISH_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (flag == 1) {
            [self AliPayWithpParameters:parameters response:response];
        }
        if (flag == 2) {
             [self WXPayWithpParameters:parameters response:response];
        }
        if (flag == 3) {
            [self BalancePayWithParameters:parameters response:response];
        }
        
    }];

   
//         [YDAlertViewController showWithViewTitle:@"提示" Defaulthandlertitle:@"确定" message:@"当前不可用" inVC:self defaulthandlerAction:nil];
//    }
}
#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

#pragma mark -- 支付
-(void)AliPayWithpParameters:(NSDictionary *)parameters response:(YDResponse *)response{
//    [YDBaseRequest starPostRequest:REWARD_WISH_URL parameters:parameters comletionHandler:^(YDResponse *response) {
                    if (response.success) {
    NSLog(@"%@",response.resultVaule);
    NSString *order = response.resultVaule[@"code"];
    //调用支付宝支付
    [[AlipaySDK defaultService] payOrder:order fromScheme:@"CilckPay" callback:^(NSDictionary *resultDic) {
        NSLog(@"支付结果%@",resultDic);
    }];
//                    }
//    }];
                    }
}

-(void)WXPayWithpParameters:(NSDictionary *)parameters response:(YDResponse *)response{
//    [YDBaseRequest starPostRequest:REWARD_WISH_URL parameters:parameters comletionHandler:^(YDResponse *response) {
    PayReq * request = [[PayReq alloc] init];
    request.partnerId = response.resultVaule[@"partnerid"];
    request.prepayId = response.resultVaule[@"prepayid"];
    request.package = response.resultVaule[@"package"];
    request.nonceStr = response.resultVaule[@"noncestr"];
    request.timeStamp = [response.resultVaule[@"timestamp"] intValue];
    request.sign = response.resultVaule[@"sign"];
    [WXApi sendReq:request];
//    }];
}

-(void)BalancePayWithParameters:(NSDictionary *)parameters response:(YDResponse *)response{
    NSLog(@"%@",response.resultVaule);
    NSDictionary * parameter = @{@"order_id":response.resultVaule[@"order_sn"]};
    [YDBaseRequest starPostRequest:REWARD_WISH_URL parameters:parameter comletionHandler:^(YDResponse *response) {
        if (response.success) {
             NSLog(@"支付结果%@",response.resultVaule);
        }else{
            NSLog(@"支付失败%@",response.resultDesc);
        }
       
    }];
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_SIZE.width, 55*SCREEN_HEIGHT_SCALE)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20*SCREEN_WIDTH_SCALE, 15*SCREEN_WIDTH_SCALE, 75, 25)];
        label.text = @"打赏金额";
        label.font = [UIFont systemFontOfSize:15];
        _textField = [[YDTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 15*SCREEN_WIDTH_SCALE, (SCREEN_SIZE.width - 100*SCREEN_WIDTH_SCALE), 25)];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.placeholder = @"输入金额";
        _textField.font = [UIFont systemFontOfSize:14];
        [_textField addyuan];
        [_headView addSubview:_textField];
        [_headView addSubview:label];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_headView.frame) + 10, SCREEN_SIZE.width, 171*SCREEN_HEIGHT_SCALE)];
           NSArray *imageArray = @[[UIImage imageNamed:@"愿望-支付宝"],[UIImage imageNamed:@"愿望-微信"],[UIImage imageNamed:@"愿望-余额"]];
            NSArray *labelArray = @[@"支付宝支付",@"微信支付",@"余额支付(剩余¥0.00)"];
        for (int i = 0; i < imageArray.count; i ++) {
            YDHomeSpareView *view = [[YDHomeSpareView alloc] initWithFrame:CGRectMake(0, i*57 , SCREEN_SIZE.width, 55)];
            view.imageView.image = imageArray[i];
            view.titleLabel.text = labelArray[i];
            view.deleagte = self;
            view.tag = 101+i;
            [_centerView addSubview:view];
        }
        _centerView.backgroundColor = APP_BACKGROUND_COLOR;
    }
    return _centerView;
}

-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.bounds = CGRectMake(0, 0, 360, 40);
        _button.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_centerView.frame)+60);
        [_button setTitle:@"确认打赏" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button.backgroundColor = COLOR_RGB(154, 154, 154, 1);
        [_button addTarget:self action:@selector(onThePayBtn) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.cornerRadius = 5;
        _button.layer.masksToBounds = YES;
    }
    return _button;
}


@end
