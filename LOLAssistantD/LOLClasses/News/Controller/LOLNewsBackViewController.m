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
    UITabBar                *_bottomTabbar;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [_newsController moveToLeft];
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



@end
