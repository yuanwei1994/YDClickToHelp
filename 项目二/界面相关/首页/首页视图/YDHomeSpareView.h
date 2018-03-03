//
//  YDHomeSpareView.h
//  ClickToHelp
//
//  Created by rimi on 16/11/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDHomeSpareView;
@protocol YDHomeSpareViewDelegate <NSObject>

- (void)homeSpareViewDidPressed:(YDHomeSpareView *)homeSpareView;

@end

@interface YDHomeSpareView : UIView
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,assign) BOOL selected;
@property(nonatomic, weak) id<YDHomeSpareViewDelegate> deleagte;

@end
