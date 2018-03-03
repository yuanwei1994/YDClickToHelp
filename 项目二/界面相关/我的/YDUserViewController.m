//
//  YDUserViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/2.
//  Copyright © 2016年 Candy. All rights reserved.
//

#import "YDUserViewController.h"
#import "YDLoginViewController.h"
//三个菜单小按钮
#import "YDUserWishViewController.h"
#import "YDUSerRewardViewController.h"
#import "YDUserCollectViewController.h"
//5个cell
#import "YDUserWishSurplusNumberViewController.h"
#import "YDMoneyPackageViewController.h"
#import "YDAdviceFeedbackViewController.h"
#import "YDAboutMeViewController.h"
#import "YDUserSettingViewController.h"

#import "YDURL.h"
#import "YDConfig.h"
#import "YDButton.h"
#import "YDUserCell.h"
#import "YDUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "YDUserRequest.h"

#define CELL_IDENTIFIER @"cellIdentifier"

typedef enum topMenu {
    menu0 = 0,
    menu1,
    menu2
}topMenu;

@interface YDUserViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *topView;          //顶部视图
@property (nonatomic, strong) YDButton *headButton;     //头像按钮
@property (nonatomic, strong) UIView *topMenuView;      //顶部中的下部分菜单视图
@property (nonatomic, strong) UITableView *tableView;   //
@property (nonatomic, strong) NSArray *dataSource;      //列表数据

@property (nonatomic, strong) YDUserModel *userModel;   //用户模型

@property (nonatomic, copy) NSString *headImageUrl;     //上传图片获取到的地址

@end

@implementation YDUserViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserUI];
    
}

//加载界面
- (void)initUserUI {
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.topMenuView];
    [self.view addSubview:self.tableView];
    self.dataSource = @[@[@"愿望次数", @"钱包"], @[@"关于我们", @"建议反馈", @"设置"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //用户单例
    self.userModel = [YDUserModel shareUserModel];
    
    if (self.userModel.isLogin == YES) {
        [self.headButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,self.userModel.avatar]]  forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"个人中心-默认头像"]];
        [self.headButton setTitle:self.userModel.user_nicename forState:UIControlStateNormal];
    } else {
        [self.headButton setImage:[UIImage imageNamed:@"个人中心-默认头像"] forState:UIControlStateNormal];
        [self.headButton setTitle:@"点击登录注册" forState:UIControlStateNormal];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- action
//头像按钮点击事件
- (void)onHeadButton:(UIButton *)sender {
    if (self.userModel.isLogin) {
        //如果用户已经登录,就进行头像修改上传功能
        [self onAddImageButton];
        
    } else {
        //未登录就提醒用户登录并跳转到登录界面
        YDLog(@"请登录");
        [self.navigationController pushViewController:[YDLoginViewController new] animated:YES];
    }
}

- (void)onMenuButton:(UIButton *)sender {
    if (!self.userModel.isLogin) {
        //如果用户未登录就提醒用户登录并跳转到登录界面
        YDLog(@"请登录");
        [self.navigationController pushViewController:[YDLoginViewController new] animated:YES];

    } else {
        //如果用户已经登录,就可以点进去
        if (sender.tag == 100) {    //愿望
            [self.navigationController pushViewController:[YDUserWishViewController new] animated:YES];
        }
        
        if (sender.tag == 101) {    //打赏
            [self.navigationController pushViewController:[YDUSerRewardViewController new] animated:YES];

        }
        if (sender.tag == 102) {    //收藏
            [self.navigationController pushViewController:[YDUserCollectViewController new] animated:YES];
        }
    }
    
}


#pragma mark -- 相机相册获取图片 - //上传头像 ---------start---------------------
- (void)onAddImageButton{
    YDLog(@"选择图片");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择设备" preferredStyle:UIAlertControllerStyleActionSheet];
    //管理系统相机相册的控制器 UIImagePickerController
    __block UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //设置代理
    picker.delegate = self;
    //运行编辑
    picker.allowsEditing = YES;
    
    //添加行为
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //推出相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //打开摄像头
            //修改数据源类型
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            YDLog(@"模拟器暂时不支持相机");
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //推出相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        picker = nil;
    }]];
    //退出alert 模态推送
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- UIImagePikerCotrollerDelegate
//图片选择完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    YDLog(@"完成选择 - info = %@",info);
    
    if ([info [UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
//        [self.headButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        self.headImageUrl = info[@"UIImagePickerControllerReferenceURL"];
#pragma mark -- 上传头像网络请求
//        [YDUserRequest uploadAvatar:nil filePath:self.headImageUrl comletionHandler:^(YDResponse *response) {
//            if (response.success) {
//                
//                YDLog(@"头像上传成功");
//                self.userModel.avatar = self.headImageUrl;
//            } else {
//                YDLog(@"头像上传失败");
//            }
//        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 相机相册获取图片 - //上传头像 ---------end---------------------


#pragma mark -- dataSource && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.section][indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) { //关于我们
        YDLog(@"关于我们");
        [self.navigationController pushViewController:[YDAboutMeViewController new] animated:YES];
    } else {
        if (self.userModel.isLogin) {   //用户已登录的情况下
            if (indexPath.section == 0 && indexPath.row == 0) { //愿望次数
                [self.navigationController pushViewController:[YDUserWishSurplusNumberViewController new] animated:YES];
            }
            if (indexPath.section == 0 && indexPath.row == 1) { //钱包
                [self.navigationController pushViewController:[YDMoneyPackageViewController new] animated:YES];
            }
            if (indexPath.section == 1 && indexPath.row == 1) { //建议反馈
                [self.navigationController pushViewController:[YDAdviceFeedbackViewController new] animated:YES];
            }
            if (indexPath.section == 1 && indexPath.row == 2) { //设置
                [self.navigationController pushViewController:[YDUserSettingViewController new] animated:YES];
            }
        } else {
            //如果用户未登录就跳转到登录界面
            [self.navigationController pushViewController:[YDLoginViewController new] animated:YES];
            
        }
    }
    
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark -- getter
//顶部视图
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 250 * SCREEN_HEIGHT_SCALE)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 250 * SCREEN_HEIGHT_SCALE)];
        imageView.image = [UIImage imageNamed:@"个人中心-头像背景"];
        [_topView addSubview:imageView];
        [_topView addSubview:self.headButton];
        
    }
    return _topView;
}
//头像按钮
- (YDButton *)headButton {
    if (!_headButton) {
        CGFloat btnWidth = 100;
        _headButton = [[YDButton alloc] initWithTitleRect:CGRectMake(0, btnWidth - 30, btnWidth, 30) ImageRect:CGRectMake(15, 0, btnWidth - 30, btnWidth - 30)];
        _headButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
        _headButton.center = self.topView.center;
        [_headButton setImage:[UIImage imageNamed:@"个人中心-默认头像"] forState:UIControlStateNormal];
        [_headButton setTitle:@"点击登录注册" forState:UIControlStateNormal];
        [_headButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _headButton.imageView.layer.cornerRadius = (btnWidth-30)/2;
        _headButton.layer.masksToBounds = YES;
        _headButton.titleLabel.textAlignment =  NSTextAlignmentCenter;
        [_headButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_headButton addTarget:self action:@selector(onHeadButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headButton;
}

- (UIView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_SIZE.width, 40)];
        _topMenuView.backgroundColor = COLOR_RGB(148, 135, 136, 1);
        CGFloat btnWidth = 40.0;
        CGFloat spaceWith = 40.0 * SCREEN_HEIGHT_SCALE;
        NSArray *titleArray = @[@"愿望",@"打赏",@"收藏"];
        for (int i = 0; i < titleArray.count; i ++) {
            YDButton *btn = [[YDButton alloc] initWithTitleRect:CGRectMake(0, btnWidth - 15, btnWidth, 15) ImageRect:CGRectMake(8, 5, btnWidth - 16, btnWidth - 20)];
            btn.tag = 100 + i;
            
            switch (i) {
                case menu0:
                    btn.frame = CGRectMake(spaceWith, 0, btnWidth, btnWidth);
                    break;
                case menu1:
                    btn.frame = CGRectMake(_topMenuView.frame.size.width / 2 - btnWidth/2, 0, btnWidth, btnWidth);
                    break;
                case menu2:
                    btn.frame = CGRectMake(_topMenuView.frame.size.width - spaceWith - btnWidth, 0, btnWidth, btnWidth);
                    break;
            }
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"个人中心-%@",titleArray[i]]] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(onMenuButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topMenuView addSubview:btn];
        }
        
        
    }
    return _topMenuView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topMenuView.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - 44 - self.topView.frame.size.height - self.topMenuView.frame.size.height ) style:UITableViewStylePlain];
        _tableView.rowHeight = 50 * SCREEN_HEIGHT_SCALE;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"YDUserCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];

        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = APP_BACKGROUND_COLOR;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
