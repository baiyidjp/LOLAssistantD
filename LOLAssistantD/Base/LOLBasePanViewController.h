//
//  LOLBasePanViewController.h
//  LOLAssistantD
//
//  Created by tztddong on 2016/11/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LOLBasePanViewControllerDelegate <NSObject>

- (void)baseViewMoveTo:(CGFloat)x animaition:(BOOL)animation;

- (void)didSelectHeadIcon;

@end

@interface LOLBasePanViewController : LOLBaseViewController

@property(nonatomic,weak)id<LOLBasePanViewControllerDelegate> delegate;

- (void)moveToLeft;

- (void)moveToRight;

@end
