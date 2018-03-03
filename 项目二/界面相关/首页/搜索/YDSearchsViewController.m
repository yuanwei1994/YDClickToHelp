//
//  YDSearchsViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/4.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDSearchsViewController.h"
#import "YDWishDetailViewController.h"

#import "YDHomeTableViewCell.h"
#import "YDConfig.h"
#import "YDHomeRequest.h"
#import "YDAlertViewController.h"

@interface YDSearchsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UITextField * textfield;
@property (nonatomic,strong) UIView * headView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation YDSearchsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setSomeThing{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    UIView *searView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-5, 0, 40, 20);
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(onsearchItem) forControlEvents:UIControlEventTouchUpInside];
    [searView addSubview:btn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searView];
    self.navigationItem.titleView = self.imageView;
    
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource.count == 0) {
        return 0;
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchcell" forIndexPath:indexPath];
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

#pragma  mark -- ButtonAction
-(void)onhotSearchButton:(UIButton*)sender{
    self.textfield.text = sender.titleLabel.text;
}

-(void)onbackItem{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)onsearchItem{
    self.tableView.hidden = NO;
    [YDHomeRequest getWishListWithSearchKeyWord:_textfield.text pageIndex:1 comletionHandler:^(YDResponse *response) {
        if (response.success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:response.resultVaule];
            [self.tableView reloadData];
        }
    }];
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        _imageView.image = [UIImage imageNamed:@"搜索框"];
        _imageView.userInteractionEnabled = YES;
        UIImageView * leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"放大镜"]];
        leftImage.frame = CGRectMake(5, 5, 20, 20);
        self.textfield = [[UITextField alloc] initWithFrame:CGRectMake(30, 5, CGRectGetWidth(_imageView.frame) - 20, 20)];
        self.textfield.placeholder = @"请输入关键字";
        self.textfield.font = [UIFont systemFontOfSize:13];
        [_imageView addSubview:leftImage];
        [_imageView addSubview:self.textfield];
    }
    return _imageView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width,SCREEN_SIZE.width/4)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 30)];
        label.text = @"热门搜索";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [_headView addSubview:label];
        NSArray * btnStr = @[@"父母",@"公益",@"奋斗"];
        for (int i =0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + i*70, CGRectGetMaxY(label.frame), 50, 30);
            [btn setTitle:btnStr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(onhotSearchButton:) forControlEvents:UIControlEventTouchUpInside];
            [_headView addSubview:btn];
        }
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - SCREEN_SIZE.width/4)];
        _tableView.rowHeight = 90;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"YDHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchcell"];
    }
    return _tableView;
}
@end
