//
//  YDWillHotViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/21.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDWillHotViewController.h"
#import "YDWillHotViewCell.h"
#import "YDHomeRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDWishModel.h"
@interface YDWillHotViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation YDWillHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预热愿望";
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [YDHomeRequest getWillHotWishListWithPageIndex:1 comlettionHandler:^(YDResponse *response) {
        [self.dataSource addObjectsFromArray:response.resultVaule];
        [self.tableView reloadData];
    }];
}

-(void)setSomeThing{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource.count == 0) {
        return 0;
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDWillHotViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    YDWishModel *model = self.dataSource[indexPath.row];
    cell.wishModel = model;
    return cell;
}

#pragma mark -- getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"YDWillHotViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 80;
    }
    return  _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
