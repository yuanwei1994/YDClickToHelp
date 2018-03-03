//
//  YDAlertViewController.m
//  ClickToHelp
//
//  Created by rimi on 16/11/9.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDAlertViewController.h"

typedef void(^onCanceBtn)(id);

@interface YDAlertViewController ()

@end

@implementation YDAlertViewController

+ (void)showWithViewTitle:(NSString *)viewtitle Canceltitle:(NSString *)canceltitle Defaulthandlertitle:(NSString *)defaulthandlertitle message:(NSString *)message inVC:(UIViewController *)vc canceAction:(void (^)())canceAction defaulthandlerAction:(void (^)())defaulthandlerAction{
    
    YDAlertViewController *alertVC = [YDAlertViewController alertControllerWithTitle:viewtitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:canceltitle style:UIAlertActionStyleCancel handler:canceAction];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:defaulthandlertitle style:UIAlertActionStyleDefault handler:defaulthandlerAction];
    [alertVC addAction:okAction];
    [alertVC addAction:delAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
    
}

+ (void)showWithViewTitle:(NSString *)viewtitle Defaulthandlertitle:(NSString *)defaulthandlertitle message:(NSString *)message inVC:(UIViewController *)vc defaulthandlerAction:(void (^)())defaulthandlerAction {
    YDAlertViewController *alertVC = [YDAlertViewController alertControllerWithTitle:viewtitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:defaulthandlertitle style:UIAlertActionStyleDefault handler:defaulthandlerAction];
    [alertVC addAction:delAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

@end
