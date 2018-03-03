//
//  YDAlertViewController.h
//  ClickToHelp
//
//  Created by rimi on 16/11/9.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDAlertViewController : UIAlertController
//- (instancetype)initWithViewTitle:(NSString*)viewtitle Canceltitle:(NSString *)canceltitle Defaulthandlertitle:(NSString*)defaulthandlertitle messageStr:(NSString *)messageStr;
+ (void)showWithViewTitle:(NSString *)viewtitle Canceltitle:(NSString *)canceltitle Defaulthandlertitle:(NSString *)defaulthandlertitle message:(NSString *)message inVC:(UIViewController *)vc canceAction:(void (^)())canceAction defaulthandlerAction:(void (^)())defaulthandlerAction;

+ (void)showWithViewTitle:(NSString *)viewtitle Defaulthandlertitle:(NSString *)defaulthandlertitle message:(NSString *)message inVC:(UIViewController *)vc defaulthandlerAction:(void (^)())defaulthandlerAction;

@end
