//
//  LOLFriendController.m
//  LOL Helper
//
//  Created by tztddong on 16/10/9.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLFriendBackController.h"
#import "LOLFriendViewController.h"

@interface LOLFriendBackController ()<LOLBasePanViewControllerDelegate>

@end

@implementation LOLFriendBackController

{
    LOLFriendViewController     *_friendViewController;
    UITabBar                    *_bottomTabbar;
    UINavigationBar             *_topNavBar;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_friendViewController moveToLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _friendViewController = [[LOLFriendViewController alloc] init];
    _friendViewController.delegate = self;
    [self addChildViewController:_friendViewController];
    _friendViewController.view.frame = self.view.bounds;
    _friendViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_friendViewController.view];
    [_friendViewController didMoveToParentViewController:self];
    
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
    
    [_friendViewController moveToRight];
}

@end
