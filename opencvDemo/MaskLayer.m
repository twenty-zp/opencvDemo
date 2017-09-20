//
//  MaskLayer.m
//  BeanCounter
//
//  Created by zp on 2017/9/13.
//  Copyright © 2017年 Nummist Media Corporation Limited. All rights reserved.
//

#import "MaskLayer.h"


@interface MaskLayer ()<CAAnimationDelegate>
{
    CABasicAnimation * _propertyAniY;
}
@end
@implementation MaskLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fillRule = kCAFillRuleEvenOdd;
        self.fillColor = [UIColor blackColor].CGColor;
        self.path = [self allScreenLayer].CGPath;
        
        CABasicAnimation * propertyAniY = [CABasicAnimation animationWithKeyPath:@"path"];
        propertyAniY.duration = 0.7;
        propertyAniY.repeatCount = 1;
        propertyAniY.removedOnCompletion = NO;
        propertyAniY.cumulative = YES;
        propertyAniY.fillMode = kCAFillModeForwards;
        propertyAniY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        _propertyAniY = propertyAniY;

    }
    return self;
}
- (void)startDraw
{
    UIBezierPath * rect = [self rectScreenLayer];

    _propertyAniY.byValue = (id)self.path;
    _propertyAniY.toValue = (id)rect.CGPath;
    [self addAnimation:_propertyAniY forKey:nil];
}

- (UIBezierPath *)allScreenLayer
{
    UIBezierPath * Allpath = [UIBezierPath bezierPath];
    
    [Allpath moveToPoint:CGPointMake(0, 0)];
    [Allpath addLineToPoint:CGPointMake( [UIScreen mainScreen].bounds.size.width, 0)];
    [Allpath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [Allpath addLineToPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height)];
    [Allpath closePath];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake( [UIScreen mainScreen].bounds.size.width, 0)];
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height)];
    [path closePath];
    [Allpath appendPath:path];
    return Allpath;
}
- (UIBezierPath *)rectScreenLayer
{
    UIBezierPath * Allpath = [UIBezierPath bezierPath];
    [Allpath moveToPoint:CGPointMake(0, 0)];
    [Allpath addLineToPoint:CGPointMake( [UIScreen mainScreen].bounds.size.width, 0)];
    [Allpath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [Allpath addLineToPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height)];
    [Allpath closePath];

    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:_lt];
    [path addLineToPoint:_rt];
    [path addLineToPoint:_rb];
    [path addLineToPoint:_lb];
    [path closePath];
    [Allpath appendPath:path];
    return  Allpath;
}

- (void)stopDraw
{

    UIBezierPath * rect = [self allScreenLayer];
    _propertyAniY.byValue = (id)self.path;
    _propertyAniY.toValue = (id)rect.CGPath;
    [self addAnimation:_propertyAniY forKey:nil];
}

@end
