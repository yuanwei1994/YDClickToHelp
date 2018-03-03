//
//  YDWishDetailViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDWishDetailViewController.h"
#import "YDHomeSpareViewController.h"
#import "YDLoginViewController.h"
#import "YDUserModel.h"

#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDURL.h"
#import "YDConfig.h"
#import "YDTimestampToDate.h"
#import "YDWishDetailViewCell.h"
#import "YDHomeRequest.h"

#define CELL_IDENTIFIER @"cellIdentifier"

@interface YDWishDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    CGFloat _spaceWidth;      //与屏幕保持的间隔
}
@property (nonatomic, strong) UITableView       *tableView;          //评论页面
@property (nonatomic, strong) UIView            *tableHeadView; //评论头部视图
@property (nonatomic, strong) UIView            *HeadView;      //页面的头部视图
@property (nonatomic, strong) UIButton          *rightButton;        //导航栏收藏按钮
@property (nonatomic, strong) UIScrollView      *imageScrollView;    //图片轮播
@property (nonatomic, strong) UIImageView       *imageView;          //图片视图

@property (nonatomic, strong) UILabel           *wishTitleLabel;     //愿望标题
@property (nonatomic, strong) UIButton          *headImageButton;    //头像
@property (nonatomic, strong) UILabel           *nicknameLabel;      //昵称
@property (nonatomic, strong) UIView            *wishDateView;       //金额 & 剩余天数视图
@property (nonatomic, strong) UILabel           *totalAmountLabel;   //总金额
@property (nonatomic, strong) UILabel           *dateLabel;          //剩余天数
@property (nonatomic, strong) UIProgressView    *progressView;       //完成进度
@property (nonatomic, strong) UILabel           *progressLabel;      //进度百分比
@property (nonatomic, strong) UILabel           *rewardLabel;        //已打赏视图
@property (nonatomic, strong) UIButton          *supportButton;      //已支持
@property (nonatomic, strong) UITextView        *commentsTextView;   //评论标签

@property (nonatomic, strong) UIView            *bottomView;         //底部视图

@property (nonatomic,strong) NSMutableArray *dataSoure;

@end

@implementation YDWishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _spaceWidth = 20.0;
    
    [self initUserUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [YDHomeRequest getWishCommentsWithWishId:self.wishModel.wish_id comletionHandler:^(YDResponse *response) {
        if (response.success) {
            [self.dataSoure removeAllObjects];
            [self.dataSoure addObjectsFromArray:response.resultVaule];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
}

//加载界面
- (void)initUserUI {
    self.title = @"愿望详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    YDLog(@"-----%@",self.wishModel);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.HeadView];
    [self.view addSubview:self.bottomView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

#pragma mark -- action

- (void)onCollectButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        YDLog(@"选中我啦,收藏啦!");
    } else {
        YDLog(@"取消啦,好气人啦!");
    }
}

- (void)onHeadImageButton {
    YDLog(@"查看该用户信息");
}

- (void)onSupportButton {
    YDLog(@"已支持 - 跳转到打赏记录页面");
}

- (void)onRewardButton {
    if([YDUserModel shareUserModel].isLogin == NO){
        [self.navigationController pushViewController:[YDLoginViewController new] animated:YES];
        return;
    }
    YDLog(@"打赏");
    YDHomeSpareViewController *spareVC = [[YDHomeSpareViewController alloc] init];
    spareVC.wishModel = self.wishModel;
    [self.navigationController pushViewController:spareVC animated:YES];
    
}

-(void)onDropDown:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        CGRect frame = self.tableHeadView.frame;
        CGRect textViewFrame = _commentsTextView.frame;
        
      CGFloat height = [_commentsTextView.text boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _commentsTextView.font} context:nil].size.height + 20;
        
        frame.size.height = height;
        textViewFrame.size.height = height;
        self.tableHeadView.frame = frame;
        self.commentsTextView.frame = textViewFrame;
        [self.tableView reloadData];
    }
    if (sender.selected == NO) {
        CGRect frame = self.tableHeadView.frame;
        frame.size.height = 30;
        self.tableHeadView.frame = frame;
        self.commentsTextView.frame = frame;
        [self.tableView reloadData];
    }
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDWishDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.headImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,self.dataSoure[indexPath.row][@"avatar"]]] placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
    if (self.dataSoure[indexPath.row][@"user_nicename"]==nil) {
        cell.nameLabel.text = @"";
    }
    cell.nameLabel.text = self.dataSoure[indexPath.row][@"user_nicename"];
    cell.dataLabel.text = self.dataSoure[indexPath.row][@"createtime"];
    cell.massageLabel.text = self.dataSoure[indexPath.row][@"content"];
    return cell;
}

#pragma mark -- getter
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 20, 20);
            [button setImage:[UIImage imageNamed:@"愿望-收藏"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"愿望-收藏选中"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onCollectButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rightButton;
}

-(UIView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        _tableHeadView.backgroundColor = [UIColor grayColor];
        UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 20, 30)];
        textView.text = @"asdasdasdjasiodjaosidjioasjdioasjdioasjdoiasjdoiasjdioasjdioasjdioasjdioasjdioajsdoiajsodijasiodjasiodjasiodjioasjdoiasjdioasjdioasjdiosa";
        textView.font = [UIFont systemFontOfSize:17];
        textView.backgroundColor = [UIColor grayColor];
//        [textView sizeToFit];
//        [[textView.text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]]
        _commentsTextView = textView;
        [_tableHeadView addSubview:_commentsTextView];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_SIZE.width - 30, 0, 20, 20);
        [btn setImage:[UIImage imageNamed:@"好友-向下"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onDropDown:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeadView addSubview:btn];
        
    }
    return _tableHeadView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 460, SCREEN_SIZE.width, SCREEN_SIZE.height - 108 - 400)];
        _HeadView.backgroundColor = [UIColor grayColor];
        _tableView.rowHeight = 60;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"YDWishDetailViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.tableHeadView;
    }
    return _tableView;
}

- (UIView *)HeadView {
    if (!_HeadView) {
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, 400)];
        _HeadView.backgroundColor = [UIColor yellowColor];
        
        [_HeadView addSubview:self.imageScrollView];
        [_HeadView addSubview:self.wishTitleLabel];
        [_HeadView addSubview:self.headImageButton];
        [_HeadView addSubview:self.nicknameLabel];
        [_HeadView addSubview:self.totalAmountLabel];
        [_HeadView addSubview:self.dateLabel];
        [_HeadView addSubview:self.progressView];
        [_HeadView addSubview:self.progressLabel];
        [_HeadView addSubview:self.rewardLabel];
        [_HeadView addSubview:self.supportButton];
        
        
    }
    return _HeadView;
}


- (UIScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 250 * SCREEN_HEIGHT_SCALE)];
        _imageScrollView.contentSize = CGSizeMake(3 * SCREEN_SIZE.width, 0);
        _imageScrollView.backgroundColor = [UIColor yellowColor];
        _imageScrollView.pagingEnabled = YES;
        
    }
    return _imageScrollView;
}

- (UILabel *)wishTitleLabel {
    if (!_wishTitleLabel) {
        _wishTitleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(self.imageScrollView.frame) + 5, SCREEN_SIZE.width - 2 * _spaceWidth, 30)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = self.wishModel.wish_title;
            label;
        });
    }
    return _wishTitleLabel;
}

- (UIButton *)headImageButton {
    if (!_headImageButton) {
        _headImageButton = ({
            CGFloat btnWidth = 30.0;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(_spaceWidth, CGRectGetMaxY(self.wishTitleLabel.frame) + 5, btnWidth, btnWidth);
            [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_wishModel.avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
            [button addTarget:self action:@selector(onHeadImageButton) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = btnWidth / 2;
            button.layer.masksToBounds = YES;
            button;
        });
    }
    return _headImageButton;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = ({
            CGFloat labelHeight = 30.0;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageButton.frame) + 5, CGRectGetMidY(self.headImageButton.frame) - labelHeight / 2, SCREEN_SIZE.width - 40, labelHeight)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = self.wishModel.user_nicename;
            label;
        });
    }
    return _nicknameLabel;
}

- (UILabel *)totalAmountLabel {
    if (!_totalAmountLabel) {
        _totalAmountLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(self.headImageButton.frame) + 5, 100, 30)];
            [label setFont:[UIFont systemFontOfSize:15]];
            int price = [self.wishModel.wish_price intValue];
            label.text = [NSString stringWithFormat:@"%d",price];
            label;
        });
    }
    return _totalAmountLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = ({
            CGFloat labelWidth = 100.0;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 2 * _spaceWidth - labelWidth, CGRectGetMaxY(self.headImageButton.frame) + 5, labelWidth, 30)];
            [label setFont:[UIFont systemFontOfSize:15]];
            //获取系统当前的时间
            NSDate * nowDate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd"];
            NSString *  locationString=[dateformatter stringFromDate:nowDate];
            //今日时间戳
            NSString *nowTimestamp = [YDTimestampToDate setTimestampWithDate:locationString];
            //结束日期转成时间戳
            NSString *endTimestamp = [YDTimestampToDate setTimestampWithDate:self.wishModel.wish_end_time];
            int date = ([endTimestamp doubleValue] - [nowTimestamp doubleValue] ) / (60 * 60 * 24);
            if (date <= 0) {
                date = 0;
            }
            
            NSString *dayStr = [NSString stringWithFormat:@"%d", date];
            
            NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还剩余%@天",dayStr]];
            NSInteger dayStrLength = dayStr.length;
            [labelString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, dayStrLength)];
            label.textAlignment = NSTextAlignmentRight;
            label.attributedText = labelString;
            label;
        });
    }
    return _dateLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(_spaceWidth, CGRectGetMaxY(self.totalAmountLabel.frame) + 5, SCREEN_SIZE.width - _spaceWidth * 3 - 5, 1);
        _progressView.progress = 0.5;
        _progressView.progressTintColor = APP_MAIN_COLOR;
        
    }
    return _progressView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progressView.frame) + 5, CGRectGetMaxY(self.totalAmountLabel.frame), 30, 10)];
            [label setFont:[UIFont systemFontOfSize:13]];
            label.text = [NSString stringWithFormat:@"%0.f%%",([self.wishModel.wish_reward_price floatValue]/[self.wishModel.wish_price floatValue])*100];
            label.textColor = APP_MAIN_COLOR;
            label;
        });
        
    }
    return _progressLabel;
}

- (UILabel *)rewardLabel {
    if (!_rewardLabel) {
        _rewardLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(self.progressView.frame), 150, 30)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = [NSString stringWithFormat:@"已打赏：￥%@ |",self.wishModel.wish_reward_price];
            label;
        });
    }
    return _rewardLabel;
}

- (UIButton *)supportButton {
    if (!_supportButton) {
        _supportButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetMaxX(self.rewardLabel.frame) + 5, CGRectGetMaxY(self.progressView.frame), 80, 30);
            [button setTitle:[NSString stringWithFormat:@"已支持 %@", self.wishModel.wish_reward_num] forState:UIControlStateNormal];
            [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onSupportButton) forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            button.backgroundColor = [UIColor yellowColor];
            button;
        });
    }
    return _supportButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height - 44, SCREEN_SIZE.width, 44)];
        _bottomView.backgroundColor = COLOR_RGB(239, 239, 239, 1);
        
        UIButton *rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rewardButton.frame = CGRectMake(2 * _spaceWidth, 5, 200, 44 - 5*2);
        [rewardButton setTitle:@"打赏" forState:UIControlStateNormal];
        [rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rewardButton setBackgroundColor:APP_MAIN_COLOR];
        [rewardButton addTarget:self action:@selector(onRewardButton) forControlEvents:UIControlEventTouchUpInside];
        [rewardButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_bottomView addSubview:rewardButton];
        
        
    }
    return _bottomView;
}

-(NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

@end
