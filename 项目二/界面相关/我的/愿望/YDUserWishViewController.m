//
//  YDUserWishViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserWishViewController.h"
#import "YDWishDetailViewController.h"

#import "YDUserWishTableViewCell.h"


#import "YDUserModel.h"
#import "YDWishModel.h"
#import "YDConfig.h"
#import "YDUserRequest.h"
#import "MJRefresh.h"

#define CELL_IDENTIFIER @"cellIdentifier"

@interface YDUserWishViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YDUserModel *userModel;       //用户模型
@property (nonatomic, strong) UITableView *tableView;       //
@property (nonatomic, strong) NSMutableArray *dataSource;   //个人发布愿望数据源



@end

@implementation YDUserWishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserUI];
}
//界面加载
- (void)initUserUI {
    self.title = @"我的愿望";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self setMJRefresh];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [YDUserRequest getWishListWithWishType:1 userID:[[YDUserModel shareUserModel] user_id] pageIndex:1 comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"个人发布的愿望----%@",response.resultVaule);
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:response.resultVaule];
            [self.tableView reloadData];
        } else {
            YDLog(@"获取个人发布愿望失败!");
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)setMJRefresh {
    //下拉刷新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //重新加载数据
        [YDUserRequest getWishListWithWishType:1 userID:[[YDUserModel shareUserModel] user_id] pageIndex:1 comletionHandler:^(YDResponse *response) {
            if (response.success) {
                YDLog(@"个人发布的愿望----%@",response.resultVaule);
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:response.resultVaule];
                [self.tableView.mj_header endRefreshing];
            } else {
                YDLog(@"获取个人发布愿望失败!");
            }
        }];
        [self.tableView reloadData];
        
    }];
}

#pragma mark -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDUserWishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    YDWishModel *wishModel = self.dataSource[indexPath.row];
    cell.wishModel = wishModel;
    
    return cell;
}

#pragma mark -- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YDWishDetailViewController *wishDetailVC = [YDWishDetailViewController alloc];
    wishDetailVC.wishModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:wishDetailVC animated:YES];
}


#pragma mark -- getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
        _tableView.rowHeight = 90;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"YDUserWishTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
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
