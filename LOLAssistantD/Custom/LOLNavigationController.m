//
//  JPNavigationController.m
//  WeChat_D
//
//  Created by tztddong on 16/9/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLNavigationController.h"
#import "LOLBasePanViewController.h"

@interface LOLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LOLNavigationController
{
    UIImageView                         *_screenImageView;
    NSMutableArray                      *_screenImageArray;
    UIScreenEdgePanGestureRecognizer    *_panGesture;
    UIView                              *_coverView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置NavigationBar背景颜色
    [self.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_bg_for_seven"]]];
    //@{}代表Dictionary
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultGodColor}];
    //设置item字体的颜色
    [self.navigationBar setTintColor:DefaultGodColor];
    //不设置这个无法修改状态栏字体颜色
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    
    //创建pan手势
    _panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:_panGesture];
    
    //截图的View
    _screenImageView = [[UIImageView alloc] init];
    _screenImageView.frame = CGRectMake(-KWIDTH*0.6, 0, KWIDTH, KHEIGHT);
    
    // 创建截图上面的黑色半透明遮罩
    _coverView = [[UIView alloc] init];
    // 遮罩的frame就是截图的frame
    _coverView.frame = _screenImageView.frame;
    // 遮罩为黑色
    _coverView.backgroundColor = [UIColor blackColor];
    
    //截图的数组
    _screenImageArray = [NSMutableArray array];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //如果当前push进来是第一个控制器的话，（代表当前childViewCtrls里面是没有东西)
    if (self.childViewControllers.count) {
        //当前不是第一个子控制器，那么在push出去的时候隐藏底部的tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController setNavigationBarHidden:NO];
        
        // 导航栏的返回按钮
        UIImage *backImage = [UIImage imageNamed:@"nav_btn_back_tiny_normal"];
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
        [backBtn setImage:backImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
        spaceItem.width = -10;
        viewController.navigationItem.leftBarButtonItems = @[spaceItem,colseItem];
        
        //对当前屏幕截图
        [self screenShot];

    }
    //这句代码的位置是一个关键
    [super pushViewController:viewController animated:animated];
    
}

#pragma mark 返回
- (void)backBtnPressed{
    
    [self dragBegin];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.jp_x = KWIDTH;
        _screenImageView.jp_x = 0;
        _coverView.jp_x = 0;
        _coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [_coverView removeFromSuperview];
        [_screenImageView removeFromSuperview];
        [self popViewControllerAnimated:NO];
        [_screenImageArray removeLastObject];
        self.view.jp_x = 0;
    }];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    NSLog(@"popViewControllerAnimated");
//    NSInteger index = self.viewControllers.count;
//    NSString * className = nil;
//    if (index >= 2) {
//        className = NSStringFromClass([self.viewControllers[index -2] class]);
//    }
//    
//    [self.childViewControllers.la willMoveToParentViewController:nil];
//    
//    [vc.view removeFromSuperview];
//    
//    [vc removeFromParentViewController];
//    
//    if (_screenImageArray.count >= index - 1) {
//        [_screenImageArray removeLastObject];
//    }
//    
//    
//    return [super popViewControllerAnimated:animated];
//}
//- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    NSLog(@"popToViewController");
//    NSInteger removeCount = 0;
//    for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
//        if (viewController == self.viewControllers[i]) {
//            break;
//        }
//        
//        [_screenImageArray removeLastObject];
//        removeCount ++;
//        
//    }
////    _animationController.removeCount = removeCount;
//    
//    return [super popToViewController:viewController animated:animated];
//}
//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    NSLog(@"popToRootViewControllerAnimated");
//    [_screenImageArray removeAllObjects];
////    [_animationController removeAllScreenShot];
//    return [super popToRootViewControllerAnimated:animated];
//}
//
#pragma mark 手势
- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    
    // 如果当前显示的控制器已经是根控制器了，不需要做任何切换动画,直接返回
    if(self.visibleViewController == self.viewControllers[0]) return;
    
    // 判断pan手势的各个阶段
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            // 开始拖拽阶段
            [self dragBegin];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            // 结束拖拽阶段
            [self dragEnd];
            break;
            
        default:
            // 正在拖拽阶段
            [self dragging:panGesture];
            break;
    }

}

#pragma mark - dragBegin
- (void)dragBegin{
    NSLog(@"dragBegin");
    // 重点,每次开始Pan手势时,都要添加截图imageview 到window中
    [self.view.window insertSubview:_screenImageView atIndex:0];
    [self.view.window insertSubview:_coverView aboveSubview:_screenImageView];
    
    // 并且,让imgView显示截图数组中的最后(最新)一张截图
    _screenImageView.image = [_screenImageArray lastObject];

}

// 默认的将要变透明的遮罩的初始透明度(全黑)
#define kDefaultAlpha 0.6

// 当拖动的距离,占了屏幕的总宽高的3/4时, 就让imageview完全显示，遮盖完全消失
#define kTargetTranslateScale 0.75

#pragma mark - dragging
- (void)dragging:(UIPanGestureRecognizer *)panGesture{
    
    // 得到手指拖动的位移
    CGFloat offsetX = [panGesture translationInView:self.view].x;

    // 让整个view都平移     // 挪动整个导航view
    if (offsetX > 0) {
        self.view.jp_x = offsetX;
    }
    
    if (offsetX < KWIDTH) {
        _screenImageView.jp_x = (offsetX - KWIDTH) * 0.6;
    }
    
    _coverView.jp_x = _screenImageView.jp_x;
    // 让遮盖透明度改变,直到减为0,让遮罩完全透明,默认的比例-(当前平衡比例/目标平衡比例)*默认的比例
    double alpha = kDefaultAlpha - (offsetX/KWIDTH/kTargetTranslateScale) * kDefaultAlpha;
    _coverView.alpha = alpha;
}

#pragma mark - dragEnd
- (void)dragEnd{
    
    CGFloat offsexX = self.view.jp_x;
    
    if (offsexX <= 40) {
        //回到当前的界面
        [UIView animateWithDuration:0.3 animations:^{
            self.view.jp_x = 0;
        } completion:^(BOOL finished) {
            [_screenImageView removeFromSuperview];
        }];
    }else{
        //返回上一层
        [UIView animateWithDuration:0.3 animations:^{
            self.view.jp_x = KWIDTH;
            _screenImageView.jp_x = 0;
            // 让遮盖alpha变为0,变得完全透明
            _coverView.alpha = 0;
        } completion:^(BOOL finished) {
            [self popViewControllerAnimated:NO];
            [_screenImageView removeFromSuperview];
            [_coverView removeFromSuperview];
            [_screenImageArray removeLastObject];
            self.view.jp_x = 0;
        }];
    }
    
}


- (void)screenShot
{
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
    // 添加截取好的图片到图片数组
    if (snapshot) {
        [_screenImageArray addObject:snapshot];
    }
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
}

@end
