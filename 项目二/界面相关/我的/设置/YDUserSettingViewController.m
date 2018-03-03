//
//  YDUserSettingViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserSettingViewController.h"
#import "YDResetPassViewController.h"

#import "YDSettingTableViewCell.h"
#import "YDUserModel.h"
#import "YDUserRequest.h"

#define CELL_IDENTIFIER @"cellIdentifier"


@interface YDUserSettingViewController ()<UITableViewDataSource, UITableViewDelegate> {
    CGFloat _height;
    CGFloat _space;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) UITextField           *nicknameTextFeild;         //昵称
@property (nonatomic, strong) UITextField           *passwordTextFeild;         //密码
@property (nonatomic, strong) UITextField           *phoneTextFeild;            //手机号
@property (nonatomic, strong) UIButton              *clearCacheButton;          //清除缓存
@property (nonatomic, strong) UIButton              *loginOutButton;            //确认退出按钮
@property (nonatomic, strong) UIButton              *rightItemBarButton;        //导航栏右边保存按钮

@property (nonatomic, strong) YDUserModel           *userModel;                 //用户单例模型

@end

@implementation YDUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserUI];
}
//界面加载
- (void)initUserUI {
    _height = 50.0 * SCREEN_WIDTH_SCALE;
    _space = 20.0;
    
    self.title = @"设置";
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.loginOutButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemBarButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    YDLog(@"[[YDUserModel shareUserModel] user_id] = %@",[[YDUserModel shareUserModel] user_id]);
    self.userModel = [YDUserModel shareUserModel];
    [self.tableView reloadData];
//    [YDUserRequest userInfoWithUid:[[YDUserModel shareUserModel] user_id] comletionHandler:^(YDResponse *response) {
//        if (response.success) {
//            self.userModel = response.resultVaule;
//            [self.tableView reloadData];
//        }
//    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- action
- (void)onButton {
    YDLog(@"退出登录");
    self.userModel.isLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightItemBarButton {
    YDLog(@"保存");
    YDSettingTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
    NSString *nickname = cell.centerTextField.text;
    [YDUserRequest modifyUserInfoWithNickname:nickname password:nil comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"修改昵称成功");
            //重新给单例赋值
            self.userModel.user_nicename = nickname;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            YDLog(@"修改失败 - %@",response.resultDesc);
        }
    }];
    
}


#pragma mark -- dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSArray *leftArray = @[@[@"昵称", @"密码", @"手机号"],@[@"清除缓存"]];
    NSArray *centerArray = @[@[self.userModel.user_nicename, @"************", self.userModel.mobile], @[@""]];
    NSArray *imageArray  = @[@[@"", @"个人中心-right", @""], @[@"钱包-清除缓存"]];
    cell.leftLabelString = leftArray[indexPath.section][indexPath.row];
    cell.textFieldString = centerArray[indexPath.section][indexPath.row];
    cell.rightImageName  = imageArray[indexPath.section][indexPath.row];
    if (!(indexPath.section == 0 && indexPath.row == 0)) {
        cell.centerTextField.userInteractionEnabled = NO;
    }
    return cell;
}

#pragma mark -- delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * SCREEN_HEIGHT_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.title = @"修改昵称";
//            self.rightItemBarButton.hidden = NO;
            
        }
        if (indexPath.row == 1) {
            YDLog(@"修改密码");
            [self.navigationController pushViewController:[YDResetPassViewController new] animated:YES];
        }
        
    } else {
        YDLog(@"清除缓存成功!");
    }
}

#pragma mark -- getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, 220 * SCREEN_HEIGHT_SCALE) style:UITableViewStylePlain];
        _tableView.rowHeight = _height;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"YDSettingTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

- (UIButton *)loginOutButton {
    if (!_loginOutButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.tableView.frame) + 30, SCREEN_SIZE.width - 2 * _space, _height)];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = APP_MAIN_COLOR;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(onButton) forControlEvents:UIControlEventTouchUpInside];
        
        _loginOutButton = button;
    }
    return _loginOutButton;
}

- (UIButton *)rightItemBarButton {
    if (!_rightItemBarButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onRightItemBarButton) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        button.hidden = YES;
        _rightItemBarButton = button;
    }
    return _rightItemBarButton;
}

@end
