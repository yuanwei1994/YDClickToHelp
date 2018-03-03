//
//  YDResetPassViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDResetPassViewController.h"

#import "YDResetPassTableViewCell.h"

#import "YDUserRequest.h"
#import "YDUserModel.h"



#define CELL_IDENTIFIER @"cellIdentifier"

@interface YDResetPassViewController () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _space;
    CGFloat _height;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) UIButton              *resetButton;       //确认修改按钮

@property (nonatomic, copy) NSString                *oldPass;           //旧密码
@property (nonatomic, copy) NSString                *newpass;           //新密码
@property (nonatomic, copy) NSString                *newpassConfirm;    //确认密码

@end

@implementation YDResetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserUI];
}
//界面加载
- (void)initUserUI {
    _height = 50.0 * SCREEN_WIDTH_SCALE;
    _space = 20.0;
    
    self.title = @"修改密码";
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.resetButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPassword) name:UITextFieldTextDidChangeNotification object:nil];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- action
- (void)onButton {
    YDLog(@"确认修改");
    YDUserModel *userModel = [YDUserModel shareUserModel];
    if (self.oldPass != userModel.password) {
        YDLog(@"旧密码输入错误");
        return;
    }
    
    if (self.newpassConfirm != self.newpass) {
        YDLog(@"新密码与确认密码不同");
        return;
    }
    [YDUserRequest modifyUserInfoWithNickname:nil password:self.newpassConfirm comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"修改用户密码成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            YDLog(@"修改失败 - %@",response.resultDesc);
            
        }
    }];

}

- (void)setPassword {
    
    YDResetPassTableViewCell *oldPassCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    YDResetPassTableViewCell *newPassCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    YDResetPassTableViewCell *newPassConfirmPassCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    if (oldPassCell.textField.text.length <= 5 && newPassCell.textField.text.length <= 5 && newPassConfirmPassCell.textField.text.length <= 5 ) {
        YDLog(@"密码长度低于5位!");
        return;
    }
    self.oldPass = oldPassCell.textField.text;
    self.newpass = newPassCell.textField.text;
    self.newpassConfirm = newPassConfirmPassCell.textField.text;
    
}

#pragma mark -- dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

#pragma mark -- delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * SCREEN_HEIGHT_SCALE;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDResetPassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSArray *leftArray = @[@[@"旧密码"],@[@"新密码",@"确认新密码"]];
    NSArray *placeholderArray = @[@[@"请输入旧密码"], @[@"请设置新密码", @"请确认新密码"]];
    cell.leftLabelString = leftArray[indexPath.section][indexPath.row];
    cell.textFieldPlaceholderString = placeholderArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark -- getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, 170 * SCREEN_HEIGHT_SCALE) style:UITableViewStylePlain];
        _tableView.rowHeight = _height;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"YDResetPassTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}
- (UIButton *)resetButton {
    if (!_resetButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.tableView.frame) + 30, SCREEN_SIZE.width - 2 * _space, _height)];
        [button setTitle:@"确认修改" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = APP_MAIN_COLOR;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(onButton) forControlEvents:UIControlEventTouchUpInside];
        _resetButton = button;
    }
    return _resetButton;
}

@end
