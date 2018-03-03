//
//  YDUSerRewardViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUSerRewardViewController.h"

#import "YDUserRewardTableViewCell.h"

#import "YDUserModel.h"
#import "YDRewardModel.h"
#import "YDConfig.h"
#import "YDUserRequest.h"

#define CELL_IDENTIFIER @"cellIdentifier"

@interface YDUSerRewardViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;       //
@property (nonatomic, strong) NSMutableArray *dataSource;   //打赏记录数据源

@end

@implementation YDUSerRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserUI];
    
}
- (void)initUserUI {
    self.title = @"我的打赏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    //网络请求数据
    [YDUserRequest getRewardListWithUid:[[YDUserModel shareUserModel] user_id] to_uid:nil wish_id:nil comletionHandler:^(YDResponse *response) {
        if (response.success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:response.resultVaule];
            [self.tableView reloadData];
        }  else {
            YDLog(@"获取个人打赏列表失败!");
        }
       
        NSLog(@"%@",self.dataSource);
    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDUserRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    YDRewardModel *rewardModel = self.dataSource[indexPath.row];
    cell.rewardModel = rewardModel;
    
    return cell;
}

#pragma mark -- getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
        _tableView.rowHeight = 90;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"YDUserRewardTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
