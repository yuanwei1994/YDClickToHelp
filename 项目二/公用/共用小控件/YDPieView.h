//
//  YDPieView.h
//  ClickToHelp
//
//  Created by rimi on 16/11/15.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPieModel : NSObject
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UIColor * color;
@property (nonatomic, assign) CGFloat sum;
-(instancetype)initWithValue:(CGFloat)value color:(UIColor *)color sum:(CGFloat)sum;
@end
@interface YDPieView : UIView
@property (nonatomic, strong) NSArray<YDPieModel * > *pieModels;
@property (nonatomic,assign) CGFloat offset;
-(instancetype)initWithFrame:(CGRect)frame pieModels:(NSArray<YDPieModel *> *)pieModels offset:(CGFloat)offset;
-(void)reloadDatas;
@end
