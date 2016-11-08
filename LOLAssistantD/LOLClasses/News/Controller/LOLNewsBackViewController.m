//
//  LOLNewsBackViewController.m
//  LOLAssistantD
//
//  Created by tztddong on 2016/11/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLNewsBackViewController.h"
#import "LOLNewsController.h"
#import "UIView+Animation.h"

#define kRightMaxPan KWIDTH*0.8
#define kRightMinPan KWIDTH*0.25
#define kLeftMaxPan  KWIDTH*0.6

@interface LOLNewsBackViewController ()

@end

@implementation LOLNewsBackViewController
{
    LOLNewsController       *_newsController;
    UIView                  *_newsView;
    BOOL                    _isRightPan;
    BOOL                    _isStopRight;
    UIImageView             *_imageView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _newsController = [[LOLNewsController alloc] init];
    _newsView = _newsController.view;
    [self addChildViewController:_newsController];
    _newsView.frame = self.view.bounds;
    _newsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_newsView];
    [_newsController didMoveToParentViewController:self];
    
    _newsView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPan:)];
    [_newsView addGestureRecognizer:leftPan];
    
    _imageView = [[UIImageView alloc] initWithFrame:_newsView.bounds];
    [_newsView addSubview:_imageView];
    _imageView.hidden = YES;
}

#pragma mark - leftPan
- (void)leftPan:(UIPanGestureRecognizer *)panges{
    
    CGFloat panX = [panges translationInView:_newsView].x;
    
    switch (panges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"开始滑动");
            _imageView.image = [self screenImage];
            _imageView.hidden = NO;
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.tabBarController.tabBar.hidden = YES;
            if (panX >= 0) {
                if (_newsView.jp_x < KWIDTH) {
                    NSLog(@"右滑--> %f",panX);
                    _isRightPan = YES;
                    if (_isStopRight) {
                        _newsView.jp_x = kRightMaxPan + panX;
                    }else{
                        _newsView.jp_x = panX;
                    }
                }
            }else{
                if (_isStopRight) {
                    NSLog(@"左滑--> %f",panX);
                    _isRightPan = NO;
                    _newsView.jp_x = kRightMaxPan + panX;
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"手指离开");
            
            if (_isRightPan) {
                if (_newsView.jp_x > KWIDTH/4.0) {
                    [self moveViewto:CGPointMake(KWIDTH*0.8, 0) hiddenTabbar:YES];
                }else{
                    [self moveViewto:CGPointMake(0, 0) hiddenTabbar:NO];
                    
                }
            }else{
                if(_newsView.jp_x < KWIDTH*0.6){
                    [self moveViewto:CGPointMake(0, 0) hiddenTabbar:NO];
                    
                }else{
                    [self moveViewto:CGPointMake(KWIDTH*0.8, 0) hiddenTabbar:YES];
                }
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - move view
- (void)moveViewto:(CGPoint)point hiddenTabbar:(BOOL)hidden{
    
    [_newsView moveTo:point duration:0.3 option:0];
    self.tabBarController.tabBar.hidden = hidden;
    _isStopRight = hidden;
    _imageView.hidden = !hidden;
}

#pragma mark - moveX
- (void)moveX{
    
//    [LOLBaseMethod jp_XbaseAnimationWithView:_newsView From:kRightMaxPan+3 to:kRightMaxPan-3 duration:0.3 repeatCount:1];
}

#pragma mark - 截屏
- (UIImage *)screenImage{
    
    CGSize imageSize = _newsView.frame.size;
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    //获取当前的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //创建需要所截图的区域路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_newsView.bounds];
    //    //设置路径的宽和颜色
    //    CGContextSetLineWidth(contextRef, 1);
    //    [[UIColor blackColor] set];
    //将路径添加到上下文中
    CGContextAddPath(contextRef, path.CGPath);
    //截取路径内的上下文
    CGContextClip(contextRef);
    //把控制器的view中的内容渲染到上下文中
    [_newsView.layer renderInContext:contextRef];
    //取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
