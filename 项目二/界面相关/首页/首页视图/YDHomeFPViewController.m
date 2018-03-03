//
//  YDHomeFPViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeFPViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDConfig.h"
#import "YDHomeRequest.h"
#import "YDHomeFPTableViewCell.h"
#import "YDHomePastFPTableViewCell.h"

@interface YDHomeFPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView * titleView;
@property (nonatomic,strong) UITableView * tabeleView;
@property (nonatomic,strong) UITableView * pastTabeleView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * pastDataSource;
@property (nonatomic,strong) UIButton * todayBtn;
@property (nonatomic,strong) UIButton * beforeBtn;
@property (nonatomic,strong) UIButton * selectedBtn;
@end

@implementation YDHomeFPViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomeThing];
    self.dataSource = [NSMutableArray array];
    self.pastDataSource = [NSMutableArray array];
    //[self onBUtton:self.beforeBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.todayBtn.selected = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setSomeThing{
//    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabeleView];
    [self.view addSubview:self.pastTabeleView];
    self.navigationItem.titleView = self.titleView;
    [YDHomeRequest getCashBackTodayWithcomletionHandler:^(YDResponse *response) {
        [self.dataSource addObjectsFromArray:response.resultVaule];
        [self.tabeleView reloadData];
    }];
    [YDHomeRequest getPastCashbackWithcomletionHandler:^(YDResponse *response) {
        [self.pastDataSource addObjectsFromArray:response.resultVaule];
        [self.pastTabeleView reloadData];
    }];

    
}

-(void)onTodayBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.view addSubview:self.tabeleView];
    [self.pastTabeleView removeFromSuperview];
    self.beforeBtn.selected = NO;
}

-(void)onBeforeBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.view addSubview:self.pastTabeleView];
    [self.tabeleView removeFromSuperview];
    self.todayBtn.selected = NO;
}

/*
 -(void)onBUtton:(UIButton *)sender{
 if (sender == self.selectedBtn) {
 return;
 }
 sender.selected = YES;
 self.selectedBtn.selected = NO;
 self.selectedBtn = sender;
 }
 */
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.pastTabeleView) {
    return self.pastDataSource.count;
    }
    if (tableView == self.tabeleView) {
    return self.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.pastTabeleView) {
        YDHomePastFPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Pastcell" forIndexPath:indexPath];
        cell.dataLabel.text = self.pastDataSource[indexPath.row][@"date"];
        cell.priceLabel.text = self.pastDataSource[indexPath.row][@"price"];
        cell.numLabel.text = self.pastDataSource[indexPath.row][@"num"];
        return cell;
    }
    if (tableView == self.tabeleView) {
        YDHomeFPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,self.dataSource[indexPath.row][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"福包-头像"]];
        cell.MessageLabel.text = [NSString stringWithFormat:@"%@  %@获得%@元返现",self.dataSource[indexPath.row][@"user_nicename"],self.dataSource[indexPath.row][@"mobile"],self.dataSource[indexPath.row][@"price"]];
        return cell;
    }
    return nil;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width-60*SCREEN_WIDTH_SCALE, 44)];
        _titleView.backgroundColor = [UIColor clearColor];
        [_titleView addSubview:self.todayBtn];
        [_titleView addSubview:self.beforeBtn];
    }
    return _titleView;
}

-(UIButton *)todayBtn{
    if (!_todayBtn) {
        _todayBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, CGRectGetWidth(self.titleView.frame)/2, 44);
            [btn setTitle:@"今日返现" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"今日返现" forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onTodayBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn;
        });
    }
    return _todayBtn;
}

-(UIButton *)beforeBtn{
    if (!_beforeBtn) {
        _beforeBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(CGRectGetMaxX(_todayBtn.frame), 0, CGRectGetWidth(self.titleView.frame)/2, 44);
            [btn setTitle:@"往期返现" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"往期返现" forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onBeforeBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn;
        });
    }
    return _beforeBtn;
}

-(UITableView *)tabeleView{
    if (!_tabeleView) {
        _tabeleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_SIZE.width , SCREEN_SIZE.height) style:UITableViewStylePlain];
        _tabeleView.rowHeight = 60;
        _tabeleView.delegate = self;
        _tabeleView.dataSource = self;
        [_tabeleView registerNib:[UINib nibWithNibName:@"YDHomeFPTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tabeleView;
}

-(UITableView *)pastTabeleView{
    if (!_pastTabeleView) {
        _pastTabeleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,SCREEN_SIZE.width , SCREEN_SIZE.height) style:UITableViewStylePlain];
        _pastTabeleView.rowHeight = 60;
        _pastTabeleView.delegate = self;
        _pastTabeleView.dataSource = self;
        [_pastTabeleView registerNib:[UINib nibWithNibName:@"YDHomePastFPTableViewCell" bundle:nil] forCellReuseIdentifier:@"Pastcell"];
    }
    return _pastTabeleView;
}

@end
