//
//  YDButton.m
//  ClickToHelp
//
//  Created by rimi on 16/11/4.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDButton.h"

@interface YDButton ()
//传入定位
@property(nonatomic, assign) CGRect titleRect;
@property(nonatomic, assign) CGRect imageRect;

@end

@implementation YDButton

- (instancetype)initWithTitleRect:(CGRect)titleRect ImageRect:(CGRect)imageRect
{
    self = [super init];
    if (self) {
        self.titleRect = titleRect;
        self.imageRect = imageRect;
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return self.titleRect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return self.imageRect;
}

@end
