//
//  YDHomeViewController.m
//  项目二
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeViewController.h"
#import "YDSearchsViewController.h"
#import "YDHomeFPViewController.h"
#import "YDWishDetailViewController.h"
#import "YDHomeSpareViewController.h"
#import "YDHomeFPDynamicViewController.h"
#import "YDReleaseWishViewController.h"
#import "YDProjectViewController.h"
#import "YDUserWishViewController.h"
#import "YDWillHotViewController.h"

#import "YDHomeTableViewCell.h"
#import "YDSearchImageView.h"
#import "YDHomeRequest.h"
#import "YDConfig.h"
#import "YDButton.h"
#import "YDWishModel.h"

@interface YDHomeViewController()<YDSearchImageViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YDSearchImageView *imageView;
@property (nonatomic,strong) UIView * HeaderView;
@property (nonatomic,strong) UIView * leftView;
@property (nonatomic,strong) UIView * rightView;
@property (nonatomic,strong) UIView * leftFootView;
@property (nonatomic, strong) UIProgressView *leftProgressView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UILabel *managerLabel;
@property (nonatomic, strong) UILabel *leftProgressLabel;
@property (nonatomic, strong) UILabel *leftTriangleLabel;
@property (nonatomic, strong) UILabel *leftFootLabel;
@property (nonatomic, strong) UILabel *rightFootLabel;

@end

@implementation YDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setSomeThing];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self viewWliiAppearAction];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setSomeThing{
    [YDHomeRequest getWishListWithIsRecmand:YES pageIndex:1 comletionHandler:^(YDResponse *response) {
        //将整个数组作为对象赋值进去
        //[self.dataSource addObject:<#(nonnull id)#>]
        //讲数组里面的值作为对象赋值进去
        [self.dataSource addObjectsFromArray:response.resultVaule];
        YDLog(@"%@",self.dataSource);
        [self.tableView reloadData];
    }];
    self.navigationItem.titleView = self.imageView;
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]];
}

-(CGFloat)setScollView{
    [_HeaderView addSubview:[self setThingForScollView]];
    return CGRectGetMaxY([self setThingForScollView].frame);
}

-(UIView*)setThingForScollView{
    UIView * scollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 120*SCREEN_HEIGHT_SCALE)];
    scollView.backgroundColor = [UIColor grayColor];
    UIScrollView * headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 120*SCREEN_HEIGHT_SCALE)];
    headScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width*2, 0);
    headScrollView.pagingEnabled=YES;
    //弹性效果
    headScrollView.bounces=NO;
    for (int i=0; i<2; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_SIZE.width, 0, SCREEN_SIZE.width, 120*SCREEN_HEIGHT_SCALE)];
        imageView.image = [UIImage imageNamed:@"首页-picture"];
        [headScrollView addSubview:imageView];
    }
    [scollView addSubview:headScrollView];
    return scollView;
}

-(CGFloat)setbuttonView{
    [_HeaderView addSubview:[self setThingForButtonView]];
    return CGRectGetMaxY([self setThingForButtonView].frame);
}

-(UIView*)setThingForButtonView{
    CGFloat ScollViewMaxY = [self setScollView];
    NSArray *btnTitle = @[@"许个愿吧",@"查看愿望",@"预热愿望",@"我的愿望"];
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, ScollViewMaxY, SCREEN_SIZE.width, 80*SCREEN_HEIGHT_SCALE)];
    for (int i = 0;i<4; i++) {
        YDButton * button = [[YDButton alloc] initWithTitleRect:CGRectMake(0, SCREEN_SIZE.width/4 - 45, SCREEN_SIZE.width/4, 20) ImageRect:CGRectMake(25, 5, SCREEN_SIZE.width/4 - 50, SCREEN_SIZE.width/4 - 50)];
        button.frame = CGRectMake(i*SCREEN_SIZE.width/4, 0, SCREEN_SIZE.width/4, CGRectGetHeight(buttonView.frame));
        button.tag = i + 100;
        //button.backgroundColor = [UIColor colorWithRed:arc4random()%255/256.f green:arc4random()%255/256.f blue:arc4random()%255/256.f alpha:1];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页-%d",i]] forState:UIControlStateNormal];
        [button setTitle:btnTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [buttonView addSubview:button];
    }
    buttonView.backgroundColor = [UIColor whiteColor];
    return  buttonView;
}

-(void)setfootView{
    CGFloat  buttonViewMaxY = [self setbuttonView];
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonViewMaxY+10, SCREEN_SIZE.width, 190*SCREEN_HEIGHT_SCALE)];
    footView.backgroundColor = [UIColor whiteColor];
    [_HeaderView addSubview:footView];
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/2, 30*SCREEN_HEIGHT_SCALE+20*SCREEN_HEIGHT_SCALE, 1, 120*SCREEN_HEIGHT_SCALE)];
    dividerView.backgroundColor = COLOR_RGB(154, 154, 154, 1);
    [footView addSubview:dividerView];
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 30*SCREEN_HEIGHT_SCALE, SCREEN_SIZE.width/2, 160*SCREEN_HEIGHT_SCALE)];
    UITapGestureRecognizer * leftViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFootLeftView)];
    [_leftView addGestureRecognizer:leftViewTap];
    [self setLeftViewOnTheFootView];
    [footView addSubview:_leftView];
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)+1, 30*SCREEN_HEIGHT_SCALE, SCREEN_SIZE.width/2, 160*SCREEN_HEIGHT_SCALE)];
    //_rightView.backgroundColor = [UIColor blueColor];
    [self setRightViewOnTheFootView];
    [footView addSubview:_rightView];
    
    [footView addSubview:[self setThingForFootView]];
}

-(void)setLeftViewOnTheFootView{
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*SCREEN_WIDTH_SCALE, 25*SCREEN_WIDTH_SCALE, 100*SCREEN_WIDTH_SCALE, 20)];
    leftLabel.text = @"今日累计数:";
    leftLabel.font = [UIFont systemFontOfSize:13];
    UIImageView* leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"福袋max"]];
    leftImageView.frame = CGRectMake((CGRectGetMaxX(_leftView.frame) - 80*SCREEN_WIDTH_SCALE) , CGRectGetMaxY(leftLabel.frame) , 80*SCREEN_WIDTH_SCALE, 80*SCREEN_WIDTH_SCALE);
    _leftProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20*SCREEN_WIDTH_SCALE, CGRectGetHeight(_leftView.frame)/2, 60*SCREEN_WIDTH_SCALE, 20)];

    _leftFootView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_leftProgressView.frame), 60*SCREEN_WIDTH_SCALE, 50*SCREEN_WIDTH_SCALE)];
    //_leftFootView.backgroundColor = [UIColor grayColor];
    UIImageView * leftTriangleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进度小三角形"]];
    leftTriangleView.frame = CGRectMake(CGRectGetWidth(_leftFootView.frame)/2 -2.5, 0, 5, 5);
    _leftTriangleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftTriangleView.frame), 60*SCREEN_WIDTH_SCALE, 20*SCREEN_WIDTH_SCALE)];
    _leftTriangleLabel.font = [UIFont systemFontOfSize:9];
    _leftTriangleLabel.textAlignment = NSTextAlignmentCenter;
    [_leftFootView addSubview:leftTriangleView];
    [_leftFootView addSubview:_leftTriangleLabel];
    
    _leftFootLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25*SCREEN_WIDTH_SCALE, 60*SCREEN_WIDTH_SCALE, 20)];
    _leftFootLabel.font = [UIFont systemFontOfSize:13];
    _leftFootLabel.text = @"";//[NSString stringWithFormat:@"总:%@/元",self.FPdataSource[0][@"today_point"]];
    _leftFootLabel.textAlignment = NSTextAlignmentCenter;
    [_leftFootView addSubview:_leftFootLabel];
    [_leftView addSubview:self.leftProgressLabel];
    [_leftView addSubview:_leftFootView];
    [_leftView addSubview:_leftProgressView];
    [_leftView addSubview:leftLabel];
    [_leftView addSubview:leftImageView];
}

-(void)setRightViewOnTheFootView{
    UIImageView * rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱袋min"]];
    rightImageView.frame = CGRectMake(20*SCREEN_WIDTH_SCALE, 25*SCREEN_WIDTH_SCALE, 20, 20);
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightImageView.frame), 25*SCREEN_WIDTH_SCALE, 100, 20)];
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.text = @"福包累计总额:";
    _rightFootLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*SCREEN_HEIGHT_SCALE, CGRectGetMaxY(_rightView.frame) - 80*SCREEN_HEIGHT_SCALE, 100, 20)];
    _rightFootLabel.textAlignment = NSTextAlignmentCenter;
    _rightFootLabel.layer.borderWidth = 1;
    _rightFootLabel.layer.borderColor = [UIColor redColor].CGColor;
    UILabel * rightpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightFootLabel.frame) + 5, CGRectGetMaxY(_rightView.frame) - 80*SCREEN_HEIGHT_SCALE, 20, 20)];
    rightpriceLabel.text = @"元";
    rightpriceLabel.font = [UIFont systemFontOfSize:14];
    
    [_rightView addSubview:rightpriceLabel];
    [_rightView addSubview:rightImageView];
    [_rightView addSubview:rightLabel];
    [_rightView addSubview:_rightFootLabel];
}


-(UIView*)setThingForFootView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30*SCREEN_HEIGHT_SCALE)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10*SCREEN_WIDTH_SCALE, 0, 70, 30*SCREEN_HEIGHT_SCALE)];
    label.text  = @"福包信息：";
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人中心-默认头像"]];
    imageView.frame = CGRectMake(CGRectGetMaxX(label.frame) + 5, 5*SCREEN_HEIGHT_SCALE, 20*SCREEN_HEIGHT_SCALE, 20*SCREEN_HEIGHT_SCALE);
    [headView addSubview:imageView];
    _managerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, SCREEN_SIZE.width - 20*SCREEN_WIDTH_SCALE - 50 - (CGRectGetMaxX(label.frame) + 5), 30*SCREEN_HEIGHT_SCALE)];
    _managerLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview:_managerLabel];
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_managerLabel.frame), 0 , 45*SCREEN_WIDTH_SCALE, 30*SCREEN_HEIGHT_SCALE)];
    label1.text = @"详情";
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor redColor];
    label1.textAlignment = NSTextAlignmentRight;
    [headView addSubview:label1];
    UITapGestureRecognizer * headViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFootHeadView)];
    [headView addGestureRecognizer:headViewTap];
    return headView;
}

#pragma makr -- Requset

-(void)viewWliiAppearAction{
    [YDHomeRequest starPostRequest:HOME_FP_URL parameters:nil comletionHandler:^(YDResponse *response) {
        self.leftProgressLabel.text = [NSString stringWithFormat:@"%@/元",response.resultVaule[@"today_get"]];
        self.leftTriangleLabel.text = [NSString stringWithFormat:@"%.2f%%",[response.resultVaule[@"today_point"] floatValue]];
        self.leftFootLabel.text = [NSString stringWithFormat:@"总:%@/元",response.resultVaule[@"today"]];
        CGRect frame = _leftFootView.frame;
        frame.origin.x  = (60*SCREEN_WIDTH_SCALE ) * [response.resultVaule[@"today_point"] floatValue]/100   + 20*SCREEN_WIDTH_SCALE - CGRectGetWidth(_leftFootView.frame)/2;
        _leftFootView.frame = frame;
        self.managerLabel.text = [NSString stringWithFormat:@"%@ %@获得%@元返现",response.resultVaule[@"info"][@"user_nicename"],response.resultVaule[@"info"][@"mobile"],response.resultVaule[@"info"][@"coin"]];
        NSMutableString *str = [response.resultVaule[@"all"] mutableCopy];
        self.rightFootLabel.attributedText = [self setAttributedStr:str];
    }];
}

#pragma mark -- Action

-(NSMutableAttributedString*)setAttributedStr:(NSMutableString*)str{
    
    for (int i  = 0; i < 5 - str.length; i ++) {
        [str insertString:@"0" atIndex:0];
    }
    for (int i =0; i * 4 <str.length-1; i++) {
        [str insertString:@" | " atIndex:(i * 4) + 1];
    }
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]
                                                initWithString:str];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14]range:NSMakeRange(0, 13)];
    for (int i =2; i<str.length; i+=4) {
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(i, 1)];
    }
    return AttributedStr;
}

#pragma makr -- ButtonAction
-(void)onBtnAction:(UIButton *)sender{
    if (sender.tag == 100) {
        NSLog(@"btn1");
        [self.navigationController pushViewController:[YDReleaseWishViewController new] animated:YES];
    }
    if (sender.tag == 101) {
        NSLog(@"btn2");
        [self.tabBarController setSelectedIndex:1];
    }
    if (sender.tag == 102) {
        [self.navigationController pushViewController:[YDWillHotViewController new] animated:YES];
        NSLog(@"btn3");
    }
    if (sender.tag == 103) {
        [self.navigationController pushViewController:[YDUserWishViewController new] animated:YES];
        NSLog(@"btn4");
    }
}

-(void)onFootHeadView{
    NSLog(@"View");
    [self.navigationController pushViewController:[YDHomeFPViewController new] animated:YES];
}

-(void)onFootLeftView{
    //[self.navigationController pushViewController:[YDHomeSpareViewController new] animated:YES];
    [self.navigationController pushViewController:[YDHomeFPDynamicViewController new] animated:YES];
    NSLog(@"leftViwe");
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YDWishDetailViewController *wishDetailVC = [[YDWishDetailViewController alloc] init];
    YDWishModel *model = self.dataSource[indexPath.row];
    wishDetailVC.wishModel = model;
    [self.navigationController pushViewController:wishDetailVC animated:YES];
}

#pragma mark -- getter


-(UILabel *)leftProgressLabel{
    if (!_leftProgressLabel) {
        _leftProgressLabel = ({
           UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftProgressView.frame)+2, CGRectGetHeight(_leftView.frame)/2 - 9*SCREEN_WIDTH_SCALE, 50*SCREEN_WIDTH_SCALE, 20*SCREEN_WIDTH_SCALE)];
            label.font = [UIFont systemFontOfSize:9];
            label;
        });
    }
    return _leftProgressLabel;
}

-(YDSearchImageView *)imageView{
    if (!_imageView) {
      _imageView = [YDSearchImageView new];
      _imageView.delegate = self;
    }
    return _imageView;
}

-(UIView *)HeaderView {
    if (!_HeaderView) {
        _HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 410 *SCREEN_HEIGHT_SCALE)];
        _HeaderView.backgroundColor = COLOR_RGB(242, 242, 242, 1);
        [self setfootView];
    }
    return _HeaderView;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"YDHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 90;
        _tableView.tableHeaderView = self.HeaderView;
    }
    return  _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


//代理方法
-(void)pushViewController{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:[YDSearchsViewController new] animated:YES];
}

@end
