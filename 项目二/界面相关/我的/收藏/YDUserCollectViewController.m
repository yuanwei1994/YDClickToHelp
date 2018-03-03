//
//  YDUserCollectViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserCollectViewController.h"
#import "YDWishDetailViewController.h"

#import "YDUserColloectTableViewCell.h"


#import "YDUserModel.h"
#import "YDWishModel.h"
#import "YDConfig.h"
#import "YDUserRequest.h"
#import "MJRefresh.h"



#define CELL_IDENTIFIER @"cellIdentifier"

@interface YDUserCollectViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;       //
@property (nonatomic, strong) NSMutableArray *dataSource;   //个人收藏数据源

@end

@implementation YDUserCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserUI];
    
}
- (void)initUserUI {
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [YDUserRequest getWishCollectListWithComletionHandler:^(YDResponse *response) {
        if (response.success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:response.resultVaule];
            [self.tableView reloadData];
        } else {
            YDLog(@"获取个人收藏失败!");
        }
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;

}

#pragma mark -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDUserColloectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
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
        _tableView.rowHeight = 120;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"YDUserColloectTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
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
