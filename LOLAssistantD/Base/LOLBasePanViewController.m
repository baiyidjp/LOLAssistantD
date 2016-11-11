//
//  LOLBasePanViewController.m
//  LOLAssistantD
//
//  Created by tztddong on 2016/11/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLBasePanViewController.h"

#define kRightMaxPan KWIDTH*0.8
#define kRightMinPan KWIDTH*0.25
#define kLeftMaxPan  KWIDTH*0.6

@interface LOLBasePanViewController ()

@end

@implementation LOLBasePanViewController
{
    BOOL                    _isRightPan;
    BOOL                    _isStopRight;
    UIButton                *_topAlphaView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPan:)];
    [self.view addGestureRecognizer:leftPan];
    
    _topAlphaView = [[UIButton alloc] initWithFrame:self.view.bounds];
    _topAlphaView.hidden = YES;
    _topAlphaView.removeHighlightEffect = YES;
    [_topAlphaView addTarget:self action:@selector(moveToLeft) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_topAlphaView];
}

#pragma mark - leftPan
- (void)leftPan:(UIPanGestureRecognizer *)panges{
    
    CGFloat panX = [panges translationInView:self.view].x;
    
    switch (panges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"开始滑动");
            if (!_isStopRight) {
                _topAlphaView.hidden = NO;
                [_topAlphaView setBackgroundImage:[self screenImage] forState:UIControlStateNormal];
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (panX >= 0) {
                if (self.view.jp_x < KWIDTH) {
                    
                    _isRightPan = YES;
                    if (_isStopRight) {
                        self.view.jp_x = kRightMaxPan + panX;
                    }else{
                        self.view.jp_x = panX;
                    }
                }
            }else{
                if (_isStopRight) {
                    
                    _isRightPan = NO;
                    self.view.jp_x = kRightMaxPan + panX;
                }
            }
            _topAlphaView.jp_x = self.view.jp_x;
            //代理
            [self.delegate baseViewMoveTo:self.view.jp_x animaition:NO];
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"手指离开");
            
            if (_isRightPan) {
                if (self.view.jp_x > KWIDTH/4.0) {
                    [self moveToRight];
                }else{
                    [self moveToLeft];
                    
                }
            }else{
                if(self.view.jp_x < KWIDTH*0.6){
                    [self moveToLeft];
                    
                }else{
                    [self moveToRight];
                }
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - moveToLeft
- (void)moveToLeft{
    
    [self moveViewto:0 isStopR:NO];
}

#pragma mark - moveToRight
- (void)moveToRight{
    
    [self moveViewto:KWIDTH*0.8 isStopR:YES];
}

#pragma mark - move view
- (void)moveViewto:(CGFloat)x isStopR:(BOOL)isStopR{
    
    [self.view jp_viewMoveTo_X:x Y:self.view.jp_y duration:0.3 finishBlock:nil];
    [_topAlphaView jp_viewMoveTo_X:x Y:self.view.jp_y duration:0.3 finishBlock:nil];
    //代理
    [self.delegate baseViewMoveTo:x animaition:YES];
    _isStopRight = isStopR;
    _topAlphaView.hidden = !isStopR;
    
}

#pragma mark - 截屏
- (UIImage *)screenImage{
    
    // 将要被截图的view,即窗口的根控制器的view
    UIViewController *beyondVC = self.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
    if (snapshot) {
        return snapshot;
    }
    return nil;
}

@end
