//
//  leftSetBtn.m
//  LOLAssistantD
//
//  Created by tztddong on 2016/11/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLLeftSetBtn.h"

@implementation LOLLeftSetBtn

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.titleLabel.jp_x = self.imageView.jp_x + self.imageView.jp_w + KMARGIN;
}

@end
