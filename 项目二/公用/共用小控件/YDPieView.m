//
//  YDPieView.m
//  ClickToHelp
//
//  Created by rimi on 16/11/15.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDPieView.h"

@implementation YDPieModel

-(instancetype)initWithValue:(CGFloat)value color:(UIColor *)color sum:(CGFloat)sum{
    if (self = [super init]) {
        _sum = sum;
        _value = value;
        _color = color;
    }
    return self;
}

@end

@interface YDPieSliceLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat startAngle;/*开始角度*/
@property (nonatomic, assign) CGFloat endAngle;/*结束角度*/
@property (nonatomic, assign) CGPoint centerPlont;/*中心点*/
@property (nonatomic, assign) CGFloat redius;/*半径*/
@property (nonatomic, assign)BOOL selected;/*选中状态*/

-(instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngel endAngle:(CGFloat)endAngle color:(UIColor*)color;

@end

@implementation YDPieSliceLayer

-(instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngel endAngle:(CGFloat)endAngle color:(UIColor*)color{
    if (self = [super init]) {
        _centerPlont = center;
        _startAngle = startAngel;
        _endAngle = endAngle;
        _redius = radius;
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:radius startAngle:startAngel endAngle:endAngle clockwise:YES];
        self.path = path.CGPath;
        self.fillColor = color.CGColor;
    }
    return self;
}

@end

@interface YDPieView ()<CAAnimationDelegate>
@property (nonatomic, assign) CGPoint centerPolint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) CAShapeLayer *animationLayer;/*做动画的图层*/
@property (nonatomic, strong) NSMutableArray<YDPieSliceLayer*> *sliceLayerArray;
@end


@implementation YDPieView

-(instancetype)initWithFrame:(CGRect)frame pieModels:(NSArray<YDPieModel *> *)pieModels offset:(CGFloat)offset{
    if (self = [super initWithFrame:frame]) {
        NSMutableArray *models = [pieModels mutableCopy];
        for (YDPieModel *model in pieModels) {
            if (model.value == 0) {
                [models removeObject:model];
            }
        }
        
        _pieModels = [models copy];
        _offset = offset;
        _radius = (MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) - offset*2)/2 ;
        _centerPolint = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
        _sliceLayerArray = [NSMutableArray array];
        [self setupSubLayers];
        [self starAnimation];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}



-(void)setupSubLayers {
    //计算总值
    CGFloat totalValue = [[self.pieModels valueForKeyPath:@"@sum.value"] floatValue];
    CGFloat currentStartAngle = 0;
    for (YDPieModel *model in self.pieModels) {
        CGFloat startAngle = currentStartAngle;
        CGFloat endAngle = currentStartAngle + model.value /totalValue * 2 * M_PI;
        currentStartAngle = endAngle;
        YDPieSliceLayer * layer = [[YDPieSliceLayer alloc] initWithCenter:_centerPolint radius:_radius startAngle:startAngle endAngle:endAngle color:model.color];
        [self.layer addSublayer:layer];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat num = (endAngle - startAngle) / 2 + startAngle;
        label.center = CGPointMake(_centerPolint.x + self.radius/2*cos(num), _centerPolint.y + self.radius/2*sin(num));
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%0.f%%",model.value/model.sum*100];
        [self addSubview:label];
        [self.sliceLayerArray addObject:layer];
    }
}

#pragma makr -- Action
-(void)tapGestureAction:(UITapGestureRecognizer *)gesture{
    CGPoint tapPint = [gesture locationInView:self];
    YDPieSliceLayer * selectedLayer = nil;
    for (YDPieSliceLayer *sliceLayer in self.sliceLayerArray) {
        if (CGPathContainsPoint(sliceLayer.path, NULL, tapPint, YES)) {
            selectedLayer = sliceLayer;
            break;
        }
    }
    if (selectedLayer == nil) {
        return;
    }
    selectedLayer.selected = !selectedLayer.selected;
    CGFloat angle = (selectedLayer.endAngle - selectedLayer.startAngle) / 2 + selectedLayer.startAngle;
    CGFloat offsetX = self.offset * cos(angle);
    CGFloat offsetY = self.offset * sin(angle);
    if (selectedLayer.selected) {
        //让它偏移
        selectedLayer.position = CGPointMake(selectedLayer.position.x + offsetX, selectedLayer.position.y + offsetY);
    }else{
        //偏移回去
        selectedLayer.position = CGPointMake(selectedLayer.position.x - offsetX, selectedLayer.position.y - offsetY);
    }
}

-(void)starAnimation {
    self.layer.mask = self.animationLayer;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.animationLayer addAnimation:animation forKey:@"animation"];
}
#pragma mark -- Public

-(void)reloadDatas{
    for (YDPieSliceLayer * layer in self.sliceLayerArray) {
        [layer removeFromSuperlayer];
    }
    [self.sliceLayerArray removeAllObjects];
    [self setupSubLayers];
    [self starAnimation];
}


#pragma mark -- anmationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (anim == [self.animationLayer animationForKey:@"animation"]) {
        self.layer.mask = nil;
    }
}

#pragma mark -- getter

-(CAShapeLayer *)animationLayer{
    if (!_animationLayer) {
        _animationLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:self.centerPolint radius:self.radius/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        _animationLayer.path = path.CGPath;
        _animationLayer.lineWidth = self.radius;
        _animationLayer.strokeColor = [UIColor redColor].CGColor;
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeStart = 0;
        _animationLayer.strokeEnd = 0;
    }
    return _animationLayer;
}

@end
