//
//  YDMoneyPackageViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/19.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDMoneyPackageViewController.h"
#import "YDCashWithdrawViewController.h"


#import "YDUserRequest.h"
#import "YDButton.h"
#import "YDUserModel.h"


#define CELL_IDENTIFIER @"cellIdentifier"

@interface YDMoneyPackageViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UIView            *headView;        //头视图
@property (nonatomic, strong) UIView            *centerView;      //中部视图

@property (nonatomic, strong) YDButton          *payButton;       //支付按钮
@property (nonatomic, strong) YDButton          *incomeButton;    //收入按钮
@property (nonatomic, strong) UIView            *leftLineView;    //左边横线
@property (nonatomic, strong) UIView            *rightLineView;   //右边横线

@property (nonatomic, strong) UITableView       *tableView;       //
@property (nonatomic, strong) NSMutableArray    *dataSource;      //钱包数据源
@property (nonatomic, strong) NSDictionary      *dataDic;         //支出 & 收入 的所有数据

@property (nonatomic, strong) UIView            *navBarView;      //导航栏
@property (nonatomic, strong) UILabel           *balanceLabel;    //余额

@property (nonatomic, strong) YDUserModel       *userModel;

@end

@implementation YDMoneyPackageViewController {
    CGFloat _lineHeight;        //横线高度
    CGFloat _btnWidth;          //按钮图片宽度
    CGFloat _space;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUserUI];
    
}
- (void)initUserUI {
    _lineHeight = 2,0;
    _btnWidth = 50.0 * SCREEN_WIDTH_SCALE;
    _space = 60.0;
    self.title = @"我的钱包";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    self.userModel = [YDUserModel shareUserModel];
    self.balanceLabel.text = [NSString stringWithFormat:@"¥ %@",self.userModel.coin];
    
    //钱包网络请求
    [YDUserRequest getMoneyPackageWithComletionHandler:^(YDResponse *response) {
        //YDLog(@"result = %@",response.resultVaule);
        self.dataDic = response.resultVaule;
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:response.resultVaule[@"pay"]];
        [self.tableView reloadData];
        
        YDLog(@"self.dataSource1 = %@",self.dataSource);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- action
//返回按钮
- (void)onBackItem {
    [self.navigationController popViewControllerAnimated:YES];
}

//提现按钮
- (void)onCashBtn {
    YDLog(@"我要提现");
    [self.navigationController pushViewController:[YDCashWithdrawViewController new] animated:YES];
}

//支出按钮
- (void)onPayButton:(UIButton *)sender {
    YDLog(@"支出按钮");
    self.rightLineView.hidden = YES;
    self.leftLineView.hidden = NO;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.dataDic[@"pay"]];
    [self.tableView reloadData];

}
//收入按钮
- (void)onIncomeButton:(UIButton *)sender {
    YDLog(@"收入按钮");
    self.rightLineView.hidden = NO;
    self.leftLineView.hidden = YES;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.dataDic[@"income"]];
    [self.tableView reloadData];

}


#pragma mark -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YDLog(@"self.dataSource2 = %@",self.dataSource);
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSDictionary *payDic = self.dataSource[indexPath.row];
    NSString *bonus = [NSString stringWithFormat:@"%@",payDic[@"bonus"]];
    NSString *to_user_nicename = [NSString stringWithFormat:@"%@",payDic[@"to_user_nicename"]];
    NSString *add_time = [NSString stringWithFormat:@"%@",payDic[@"add_time"]];
    add_time = [add_time substringWithRange:NSMakeRange(0, 10)];
    //存在被打赏的用户昵称 to_user_nicename 说明数据源为 支出的
    if (payDic[@"to_user_nicename"]) {
        
        NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@ 打赏%@%@元",add_time, to_user_nicename, bonus] ];
        [mutableAttrStr addAttribute:NSForegroundColorAttributeName value:APP_MAIN_COLOR range:NSMakeRange(mutableAttrStr.length - 1 - bonus.length, bonus.length)];
        cell.textLabel.attributedText = mutableAttrStr;
    
    } else {
        //不存在说明该数据源为 收入的
        NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@ 收到打赏%@元",add_time, bonus] ];
        [mutableAttrStr addAttribute:NSForegroundColorAttributeName value:APP_MAIN_COLOR range:NSMakeRange(mutableAttrStr.length - 1 - bonus.length, bonus.length)];
        cell.textLabel.attributedText = mutableAttrStr;
    }
    
    return cell;
}


#pragma mark -- getter
//最顶端的视图
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 250 * SCREEN_WIDTH_SCALE)];
        _headView.backgroundColor = COLOR_RGB(51, 55, 62, 1);
        //假的导航栏
        [_headView addSubview:self.navBarView];
        CGFloat space = 20.0;
        CGFloat width = 80.0;
        //钱包余额
        UILabel *moneyPackageBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(self.navBarView.frame) + 10, width, 20)];
        moneyPackageBalanceLabel.text = @"钱包余额";
        [moneyPackageBalanceLabel setTextColor:[UIColor whiteColor]];
        [moneyPackageBalanceLabel setFont:[UIFont systemFontOfSize:13]];

        [_headView addSubview:moneyPackageBalanceLabel];
        //我要提现
        UIButton *cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cashBtn.frame = CGRectMake(SCREEN_SIZE.width - space - width, CGRectGetMinY(moneyPackageBalanceLabel.frame), width, 20);
        [cashBtn setTitle:@"我要提现" forState:UIControlStateNormal];
        [cashBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        //把按钮的内容（控件）的对齐方式修改为水平右对齐
        cashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //再把titleLabel的内容右对齐
        cashBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [cashBtn addTarget:self action:@selector(onCashBtn) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:cashBtn];
        
        [_headView addSubview:self.balanceLabel];
        
        
    }
    
    return _headView;
}
//导航栏
- (UIView *)navBarView {
    if (!_navBarView) {
        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_SIZE.width, 44)];
        //左边返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(20, 12, 20, 20);
        [backBtn setImage:[UIImage imageNamed:@"个人中心-left"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(onBackItem) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backBtn];
        
        //titleLabel
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width / 2 - 40, 12, 80, 20)];
        titleLabel.text = @"我的钱包";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_navBarView addSubview:titleLabel];
    }
    return _navBarView;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.headView.frame) - 60 * SCREEN_WIDTH_SCALE, SCREEN_SIZE.width - 2 * _space, 20)];
        _balanceLabel.text = @"¥ 0.00";
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        _balanceLabel.textColor = [UIColor whiteColor];
    }
    return _balanceLabel;
}

//中部视图
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_SIZE.width, 100 * SCREEN_WIDTH_SCALE)];
        [_centerView addSubview:self.payButton];
        [_centerView addSubview:self.incomeButton];
        [_centerView addSubview:self.leftLineView];
        [_centerView addSubview:self.rightLineView];
        
    }
    return _centerView;
}

- (YDButton *)payButton {
    if (!_payButton) {
        _payButton = ({
            YDButton *btn = [[YDButton alloc] initWithTitleRect:CGRectMake(_space + _btnWidth + 10, 40 - _lineHeight, 40, 20) ImageRect:CGRectMake(_space, 25 - _lineHeight / 2, _btnWidth, _btnWidth)];
            btn.frame = CGRectMake(0, 0, SCREEN_SIZE.width / 2, CGRectGetHeight(self.centerView.frame) - _lineHeight);
            [btn setTitle:@"支出" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"钱包-支出"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onPayButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _payButton;
}

- (YDButton *)incomeButton {
    if (!_incomeButton) {
        _incomeButton = ({
            YDButton *btn = [[YDButton alloc] initWithTitleRect:CGRectMake(_space + _btnWidth + 10, 40 - _lineHeight, 40, 20) ImageRect:CGRectMake(_space, 25 - _lineHeight / 2, _btnWidth, _btnWidth)];
            btn.frame = CGRectMake(CGRectGetMaxX(self.payButton.frame), 0, SCREEN_SIZE.width / 2, CGRectGetHeight(self.centerView.frame) - _lineHeight);
            [btn setTitle:@"收入" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"钱包-收入"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onIncomeButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _incomeButton;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payButton.frame), SCREEN_SIZE.width / 2, _lineHeight)];
            view.backgroundColor = APP_MAIN_COLOR;
            view;
        });
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width / 2, CGRectGetMaxY(self.payButton.frame), SCREEN_SIZE.width / 2, _lineHeight)];
            view.backgroundColor = APP_MAIN_COLOR;
            view.hidden = YES;
            view;
        });
    }
    return _rightLineView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.centerView.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
        _tableView.rowHeight = 50 * SCREEN_WIDTH_SCALE;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (NSDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}




@end
