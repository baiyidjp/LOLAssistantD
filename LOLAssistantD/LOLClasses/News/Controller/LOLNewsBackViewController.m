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

@interface LOLNewsBackViewController ()<LOLBasePanViewControllerDelegate>

@end

@implementation LOLNewsBackViewController
{
    LOLNewsController       *_newsController;
    BOOL                    _isRightPan;
    BOOL                    _isStopRight;
    UITabBar                *_bottomTabbar;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _newsController = [[LOLNewsController alloc] init];
    _newsController.delegate = self;
    [self addChildViewController:_newsController];
    _newsController.view.frame = self.view.bounds;
    _newsController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_newsController.view];
    [_newsController didMoveToParentViewController:self];

    _bottomTabbar = self.tabBarController.tabBar;

}

- (void)baseViewMoveTo:(CGFloat)x animaition:(BOOL)animation{
    
    if (animation) {
        [_bottomTabbar jp_viewMoveTo_X:x Y:_bottomTabbar.jp_y duration:0.3 finishBlock:nil];
    }else{
        _bottomTabbar.jp_x = x;
    }
}

- (void)didSelectHeadIcon{
    
    [_newsController moveToRight];
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
