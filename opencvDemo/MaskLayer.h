//
//  MaskLayer.h
//  BeanCounter
//
//  Created by zp on 2017/9/13.
//  Copyright © 2017年 Nummist Media Corporation Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface MaskLayer : CAShapeLayer

@property (nonatomic,assign)CGPoint lb;
@property (nonatomic,assign)CGPoint lt;
@property (nonatomic,assign)CGPoint rt;
@property (nonatomic,assign)CGPoint rb;

- (void)startDraw;
- (void)stopDraw;
@end
