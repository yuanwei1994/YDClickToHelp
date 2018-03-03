//
//  YDButton.h
//  ClickToHelp
//
//  Created by rimi on 16/11/4.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDButton : UIButton

- (instancetype)initWithTitleRect:(CGRect)titleRect ImageRect:(CGRect)imageRect;

- (CGRect)titleRectForContentRect:(CGRect)contentRect;
- (CGRect)imageRectForContentRect:(CGRect)contentRect;

@end
