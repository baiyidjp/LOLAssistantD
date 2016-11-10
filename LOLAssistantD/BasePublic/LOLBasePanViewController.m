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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPan:)];
    [self.view addGestureRecognizer:leftPan];
    
    self.topAlphaView = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.topAlphaView.hidden = YES;
    [self.topAlphaView addTarget:self action:@selector(moveToLeft) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - leftPan
- (void)leftPan:(UIPanGestureRecognizer *)panges{
    
    CGFloat panX = [panges translationInView:self.view].x;
    
    switch (panges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"开始滑动");
            self.topAlphaView.hidden = NO;
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (panX >= 0) {
                if (self.view.jp_x < KWIDTH) {
                    NSLog(@"右滑--> %f",panX);
                    _isRightPan = YES;
                    if (_isStopRight) {
                        self.view.jp_x = kRightMaxPan + panX;
                    }else{
                        self.view.jp_x = panX;
                    }
                }
            }else{
                if (_isStopRight) {
                    NSLog(@"左滑--> %f",panX);
                    _isRightPan = NO;
                    self.view.jp_x = kRightMaxPan + panX;
                }
            }
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
    //代理
    [self.delegate baseViewMoveTo:x animaition:YES];
    _isStopRight = isStopR;
    self.topAlphaView.hidden = !isStopR;
    
}

@end
