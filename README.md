# 多个按钮弹出动画

#前言
说到APP用户体验，就离不开动画。在这篇文章里，简单实现了点击一个按钮弹出多个按钮的动画，在此抛砖引玉，供大家参考。
#思路
先创建需要被弹出的多个按钮，然后创建点击弹出的POP按钮，将其覆盖在多个按钮之上，最后在POP按钮点击事件里边利用UIView动画和CABasicAnimation动画，就可以实现简单的弹出效果。
![按钮层次结构图.png](http://upload-images.jianshu.io/upload_images/1979970-8342192b43bbbf3a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#主要代码
在POP按钮点击事件中，根据按钮的选中状态来判断是弹出还是收回多个按钮。这里使用的适配，是自己写的一个UIView的分类，方便取到控件的相应属性，具体可以查看Demo。
```
/**
 按钮点击响应
 */
- (void)popAction:(UIButton *)button
{
    if (button.selected == NO)
    {
//弹出
        [self show];
        button.selected = YES;
    }
    else
    {  
//消失
        [self dismiss];
        button.selected = NO;
    }
}
```
弹出多个按钮。这里需要注意的是，弹出按钮，只是一个动画效果，按钮本身的位置还是没有改变，需要我们在动画结束后，重新设置按钮的位置。
```
/**
 弹出
 */
- (void)show
{
    //旋转弹出按钮
    [UIView animateWithDuration:popTime animations:^{
       self.popButton.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    }];
    
    
    //取出按钮，添加动画
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            button.center = CGPointMake(self.view.centerX,  self.view.centerY + 80 * idx - 250);
        });
    }];
}
```
隐藏弹出的多个按钮
```
/**
 隐藏
 */
- (void)dismiss
{
    [UIView animateWithDuration:popTime animations:^{
        self.popButton.transform = CGAffineTransformMakeRotation(0);
    }];

    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

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
            button.center = CGPointMake(_popButton.centerX,  _popButton.centerY);
        });
 
    }];
}
```
#效果图

![效果图.gif](http://upload-images.jianshu.io/upload_images/1979970-5aee063df2fdc17a.gif?imageMogr2/auto-orient/strip)
#简书地址
http://www.jianshu.com/p/4c7b65ddead6
