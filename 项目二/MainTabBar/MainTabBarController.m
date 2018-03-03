//
//  MainTabBarController.m
//  项目二
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "MainTabBarController.h"
#import "YDHomeViewController.h"
#import "YDUserViewController.h"
#import "YDMessageViewController.h"
#import "YDProjectViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *viewControllers = @[[[YDHomeViewController alloc]init],[[YDProjectViewController alloc]init],[[YDMessageViewController alloc]init],[[YDUserViewController alloc]init]];
    
    NSArray *tabBarItemTitle = @[@"首页",@"项目",@"消息",@"我的"];
    
    NSArray *tabBarItemImage = @[[UIImage imageNamed:@"icon-首页"],[UIImage imageNamed:@"icon-项目"],[UIImage imageNamed:@"icon-消息"],[UIImage imageNamed:@"icon-我的"]];
    
    NSArray *tabBarItemSelectedImage = @[[UIImage imageNamed:@"icon-selected首页"],[UIImage imageNamed:@"icon-selected项目"],[UIImage imageNamed:@"icon-selected消息"],[UIImage imageNamed:@"icon-selected我的"]];
    
    NSMutableArray * VCArray = [NSMutableArray array];
    
    for (int i = 0; i<viewControllers.count; i++) {
        UIViewController * vc = viewControllers[i];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:tabBarItemTitle[i] image:tabBarItemImage[i] selectedImage:tabBarItemSelectedImage[i]];
        vc.tabBarItem = item;
        vc.title = tabBarItemTitle[i];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.barTintColor = [UIColor colorWithRed:71/255.0 green:193/255.0 blue:182/255.0 alpha:1];
        nav.view.backgroundColor = [UIColor whiteColor];
        [VCArray addObject:nav];
    }
    self.tabBar.tintColor = [UIColor colorWithRed:76/255.0 green:206/255.0 blue:194.0 alpha:1];
    self.viewControllers = VCArray;
}


@end
