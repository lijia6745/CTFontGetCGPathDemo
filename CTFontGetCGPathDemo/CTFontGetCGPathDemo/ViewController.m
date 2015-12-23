//
//  ViewController.m
//  CTFontGetCGPathDemo
//
//  Created by 李佳 on 15/12/22.
//  Copyright © 2015年 LiJia. All rights reserved.
//

#import "ViewController.h"
#import "TimPathShowView.h"

@interface ViewController ()
@property(nonatomic, weak)TimPathShowView* showView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TimPathShowView* view = [[TimPathShowView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = self.view.frame;
    [self.view addSubview:view];
    self.showView = view;
    
    UIButton* btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(50, 50, 40, 20);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(addAnimations) forControlEvents:UIControlEventTouchUpInside];
}


- (void)addAnimations
{
    NSArray* pathArr = self.showView.paths;
    int index = arc4random() % pathArr.count;
    
    NSArray* subLayers = [self.view.layer sublayers];
    for (CALayer* subLayer in subLayers)
    {
        if ([subLayer isKindOfClass:[CAShapeLayer class]])
            [subLayer removeFromSuperlayer];
    }
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor whiteColor].CGColor;
    shapeLayer.frame = CGRectMake(100, 150, 100, 100);
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 1.0;
    shapeLayer.path = (__bridge CGPathRef)pathArr[index];
    [self.view.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 3.0;
    [shapeLayer addAnimation:animation forKey:@"strokeEnd"];
}

@end
