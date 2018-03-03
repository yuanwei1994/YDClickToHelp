//
//  YDProjectViewController.m
//  项目二
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDProjectViewController.h"
#import "YDWishDetailViewController.h"
#import "YDLoginViewController.h"

#import "YDConfig.h"
#import "YDHomeRequest.h"
#import "YDHomeTableViewCell.h"
#import "MJRefresh.h"
#import "YDUserModel.h"

@interface YDProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton * newlyWishButton;
@property (nonatomic,strong) UIButton * hotWishButton;
@property (nonatomic,strong) UITableView * tableViwe;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation YDProjectViewController{
    NSInteger _newNum;
    NSInteger _hotNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    _newNum = 2;
    _hotNum = 2;
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.newlyWishButton.selected = YES;
    [YDHomeRequest getAllWishListWithPageIndex:1 comletionHandler:^(YDResponse *response) {
        if (response.success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:response.resultVaule];
            [self.tableViwe reloadData];
        }
    }];
}

-(void)setSomeThing{
    self.tableViwe.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_newlyWishButton.isSelected) {
            [YDHomeRequest getAllWishListWithPageIndex:_newNum comletionHandler:^(YDResponse *response) {
                [self.dataSource addObjectsFromArray:response.resultVaule];
                [self.tableViwe reloadData];
                [self.tableViwe.mj_footer endRefreshing];
                _newNum ++;
            }];
        }
        if (_hotWishButton.isSelected) {
            [YDHomeRequest getHotWishListWithPageIndex:_hotNum comletionHandler:^(YDResponse *response) {
                [self.dataSource addObjectsFromArray:response.resultVaule];
                [self.tableViwe reloadData];
                [self.tableViwe.mj_footer endRefreshingWithNoMoreData];
                _hotNum ++;
            }];
        }
    }];
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.newlyWishButton];
    [titleView addSubview:self.hotWishButton];
    [self.view addSubview:self.tableViwe];
    self.navigationItem.titleView = titleView;
}


#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource.count == 0) {
        return 0;
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    YDWishModel *model = self.dataSource[indexPath.row];
    cell.wishModel = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDWishDetailViewController *wishDetailVC = [[YDWishDetailViewController alloc] init];
    YDWishModel *model = self.dataSource[indexPath.row];
    wishDetailVC.wishModel = model;
    [self.navigationController pushViewController:wishDetailVC animated:YES];
}

-(void)onnewlyWishButton:(UIButton *)sender{
    sender.selected=!sender.selected;
    _hotWishButton.selected = NO;
    [_tableViwe.mj_footer resetNoMoreData];
    [YDHomeRequest getAllWishListWithPageIndex:1 comletionHandler:^(YDResponse *response) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:response.resultVaule];
        [self.tableViwe reloadData];
    }];
}

-(void)onhotWishButton:(UIButton *)sender{
    sender.selected = !sender.selected;
    _newlyWishButton.selected = NO;
    [_tableViwe.mj_footer resetNoMoreData];
    [YDHomeRequest getHotWishListWithPageIndex:1 comletionHandler:^(YDResponse *response) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:response.resultVaule];
        [self.tableViwe reloadData];
    }];
}

-(UIButton *)newlyWishButton{
    if (!_newlyWishButton) {
        _newlyWishButton = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, SCREEN_SIZE.width/2, 44);
            [btn setTitle:@"最新愿望" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"最新愿望" forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onnewlyWishButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _newlyWishButton;
}

-(UIButton *)hotWishButton{
    if (!_hotWishButton) {
        _hotWishButton = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(CGRectGetMaxX(_newlyWishButton.frame), 0, SCREEN_SIZE.width/2, 44);
            [btn setTitle:@"热门愿望" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"热门愿望" forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onhotWishButton:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _hotWishButton;
}

-(UITableView *)tableViwe{
    if (!_tableViwe) {
        _tableViwe = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64)];
        _tableViwe.rowHeight = 90;
        _tableViwe.delegate = self;
        _tableViwe.dataSource = self;
        [_tableViwe registerNib:[UINib nibWithNibName:@"YDHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableViwe;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
