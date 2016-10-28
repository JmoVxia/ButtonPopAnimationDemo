//
//  ViewController.m
//  ButtonPopAnimationDemo
//
//  Created by JmoVxia on 2016/10/27.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SetRect.h"

#define popTime 0.15

@interface ViewController ()
/**弹出按钮 */
@property (nonatomic,strong) UIButton  *popButton;
/**按钮数组*/
@property (nonatomic,strong) NSMutableArray *buttonArray;
@end

@implementation ViewController

- (UIButton *) popButton
{
    if (_popButton == nil)
    {
        _popButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.centerX - 30, self.view.centerY - 30 + 180, 60, 60)];
       
        [self.view addSubview:_popButton];
        [_popButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popButton;
}
- (NSMutableArray *) buttonArray
{
    if (_buttonArray==nil)
    {
        _buttonArray=[[NSMutableArray alloc]init];
    }
    return _buttonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    self.popButton.backgroundColor = [UIColor grayColor];

    

}
- (void)initUI
{
    //循环创建按钮
    for (NSInteger i = 0; i<5; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.centerX - 30,self.view.centerY - 30 + 180, 60, 60)];
        //标记tag
        button.tag = 100+i;
        button.backgroundColor = [UIColor orangeColor];
        NSString *string = [NSString stringWithFormat:@"%ld",i];
        [button setTitle:string forState:UIControlStateNormal];
        button.layer.cornerRadius = 30;
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.buttonArray addObject:button];
    }
    
}

/**
 按钮点击响应
 */
- (void)popAction:(UIButton *)button
{
    if (button.selected == NO)
    {
        [self show];
        button.selected = YES;
    }
    else
    {
        [self dismiss];
        button.selected = NO;
    }
}

/**
 展示
 */
- (void)show
{
    //旋转弹出按钮
    [UIView animateWithDuration:popTime animations:^{
       self.popButton.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    }];
    
    
    //取出按钮，添加动画
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //位移动画
        UIButton *button = self.buttonArray[idx];
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
        anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(_popButton.centerX, _popButton.centerY)];
        anima.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.centerY + 80 * idx - 250)];
        anima.duration = popTime;
        anima.fillMode = kCAFillModeForwards;
        anima.removedOnCompletion = NO;
        anima.beginTime = CACurrentMediaTime() + 0.02 * idx;
        [button.layer addAnimation:anima forKey:nil];
        //缩放动画
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnima.duration = popTime;
        scaleAnima.fromValue = @0;
        scaleAnima.toValue = @1;
        scaleAnima.fillMode = kCAFillModeForwards ;
        scaleAnima.removedOnCompletion = NO ;
        scaleAnima.beginTime = CACurrentMediaTime() + 0.02 * idx;
        [button.layer addAnimation:scaleAnima forKey:nil];
        //等动画结束后，改变按钮真正位置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.center = CGPointMake(self.view.centerX,  self.view.centerY + 80 * idx - 250);
        });
    }];
}

/**
 隐藏
 */
- (void)dismiss
{
    [UIView animateWithDuration:popTime animations:^{
        self.popButton.transform = CGAffineTransformMakeRotation(0);
    }];

    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *button = self.buttonArray[idx];
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
        anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.centerY + 80 * idx - 250)];
        anima.toValue = [NSValue valueWithCGPoint:CGPointMake(_popButton.centerX, _popButton.centerY)];
        anima.duration = popTime;
        anima.fillMode = kCAFillModeForwards;
        anima.removedOnCompletion = NO;
        anima.beginTime = CACurrentMediaTime() + 0.02 * (4 - idx);
        [button.layer addAnimation:anima forKey:nil];

        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnima.duration = popTime;
        scaleAnima.fromValue = @1;
        scaleAnima.toValue = @0;
        scaleAnima.fillMode = kCAFillModeForwards ;
        scaleAnima.removedOnCompletion = NO ;
        scaleAnima.beginTime = CACurrentMediaTime() + 0.02 * (4 - idx);
        [button.layer addAnimation:scaleAnima forKey:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.center = CGPointMake(_popButton.centerX,  _popButton.centerY);
        });
 
    }];
}
//弹出的按钮点击事件
- (void)action:(UIButton *)button
{
    NSLog(@"%ld",button.tag - 100);
}



@end
