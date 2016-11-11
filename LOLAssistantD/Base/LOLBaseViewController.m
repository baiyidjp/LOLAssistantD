//
//  BaseViewController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLBaseViewController.h"
#import "JPRequestFiledView.h"

@interface LOLBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LOLBaseViewController
{
    JPRequestFiledView  *_requestView;
}
/**
 *  修改状态栏字体颜色成白色 
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_bg_for_seven"]];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)noneData{
    
    [self configRequestViewType:1];
}

- (void)noneNet{
    
    [self configRequestViewType:2];
    
}

#pragma mark - configRequestView
- (void)configRequestViewType:(NSInteger)type{
    
    _requestView = [JPRequestFiledView configViewWithFrame:self.view.bounds Type:type selectBlock:^{
        
        [_requestView removeFromSuperview];
        _requestView = nil;
        NSLog(@"请求网络");
    }];
    [self.view addSubview:_requestView];
}

@end
