//
//  YDHomeSpareView.m
//  ClickToHelp
//
//  Created by rimi on 16/11/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeSpareView.h"

#import "YDConfig.h"

@interface YDHomeSpareView ()
@property (nonatomic,strong) UIImageView * okImageView;
@end

@implementation YDHomeSpareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSomeThing];
    }
    return self;
}

-(void)setSomeThing{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap)];
    [self addGestureRecognizer:viewTap];
    self.imageView = [[UIImageView alloc] init];
      self.imageView.frame = CGRectMake(20*SCREEN_WIDTH_SCALE, 10*SCREEN_WIDTH_SCALE, 35*SCREEN_WIDTH_SCALE, 35*SCREEN_WIDTH_SCALE);
    UIImageView * okImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"愿望-打赏-选中"]];
    okImageView.frame = CGRectMake(CGRectGetMaxX(self.frame) - 50*SCREEN_WIDTH_SCALE, 15*SCREEN_WIDTH_SCALE, 25*SCREEN_WIDTH_SCALE, 25*SCREEN_WIDTH_SCALE);
    okImageView.hidden = YES;
    self.okImageView = okImageView;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 5, 10*SCREEN_WIDTH_SCALE, 180, 35)];
    label.font = [UIFont systemFontOfSize:14];
    self.titleLabel = label;
    [self addSubview:okImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];

}

-(void)onViewTap{
    if ([self.deleagte respondsToSelector:@selector(homeSpareViewDidPressed:)]) {
        [self.deleagte homeSpareViewDidPressed:self];
    }
}

#pragma mark - Setter

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.okImageView.hidden = !selected;
    YDLog(@"%ld",(long)self.tag);
}
    
@end
