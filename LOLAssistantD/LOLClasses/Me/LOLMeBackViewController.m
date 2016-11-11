//
//  LOLMeViewController.m
//  LOL Helper
//
//  Created by tztddong on 16/10/9.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLMeBackViewController.h"
#import "LOLMeViewController.h"

@interface LOLMeBackViewController ()<LOLBasePanViewControllerDelegate>

@end

@implementation LOLMeBackViewController
{
    LOLMeViewController     *_meViewController;
    UITabBar                *_bottomTabbar;
    UINavigationBar         *_topNavBar;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_meViewController moveToLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _meViewController = [[LOLMeViewController alloc] init];
    _meViewController.delegate = self;
    [self addChildViewController:_meViewController];
    _meViewController.view.frame = self.view.bounds;
    _meViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_meViewController.view];
    [_meViewController didMoveToParentViewController:self];
    
    _bottomTabbar = self.tabBarController.tabBar;
    _topNavBar = self.navigationController.navigationBar;
    
}

- (void)baseViewMoveTo:(CGFloat)x animaition:(BOOL)animation{
    
    if (animation) {
        [_bottomTabbar jp_viewMoveTo_X:x Y:_bottomTabbar.jp_y duration:0.3 finishBlock:nil];
        [_topNavBar jp_viewMoveTo_X:x Y:_topNavBar.jp_y duration:0.3 finishBlock:nil];
    }else{
        _bottomTabbar.jp_x = x;
        _topNavBar.jp_x = x;
    }
}

- (void)didSelectHeadIcon{
    
    [_meViewController moveToRight];
}



@end
