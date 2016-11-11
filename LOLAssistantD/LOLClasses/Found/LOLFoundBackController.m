//
//  LOLFoundController.m
//  LOL Helper
//
//  Created by tztddong on 16/10/9.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLFoundBackController.h"
#import "LOLFoundViewController.h"

@interface LOLFoundBackController ()

@end

@implementation LOLFoundBackController

{
    LOLFoundViewController      *_foundViewController;
    UITabBar                    *_bottomTabbar;
    UINavigationBar             *_topNavBar;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_foundViewController moveToLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _foundViewController = [[LOLFoundViewController alloc] init];
    _foundViewController.delegate = self;
    [self addChildViewController:_foundViewController];
    _foundViewController.view.frame = self.view.bounds;
    _foundViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_foundViewController.view];
    [_foundViewController didMoveToParentViewController:self];
    
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
    
    [_foundViewController moveToRight];
}

@end
