//
//  UIView+YDInspectable.m
//  ClickToHelp
//
//  Created by Candy on 16/11/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "UIView+YDInspectable.h"

@implementation UIView (YDInspectable)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}


- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

@end
