//
//  LOLNewsNormalClassView.m
//  LOL Helper
//
//  Created by tztddong on 16/10/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLNewsNormalClassView.h"
#import "LOLNewsClassModel.h"

#define CLASSBTN_TAG 20161011
@implementation LOLNewsNormalClassView
{
    UIScrollView *_classScrollView;
    UIImageView *_lineImageView;
    UIButton *_preSelectBtn;
    NSMutableArray *_buttonArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self configViews];
    }
    return self;
}

#pragma mark - 配置Views
- (void)configViews
{
    _buttonArray = [NSMutableArray array];
    
    _classScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(KMARGIN, 0, self.jp_w-2*KMARGIN, self.jp_h)];
    _classScrollView.backgroundColor = [UIColor jp_colorWithHexString:@"ffffff"];
    _classScrollView.delegate = self;
//    _classScrollView.pagingEnabled = YES;
    _classScrollView.showsHorizontalScrollIndicator = NO;
    _classScrollView.showsVerticalScrollIndicator = NO;
//    _classScrollView.bounces = NO;
    _classScrollView.userInteractionEnabled = YES;
    [self addSubview:_classScrollView];
    
    _lineImageView = [[UIImageView alloc]init];
    _lineImageView.image = [UIImage imageNamed:@"personal_segment_selected_mark"];
}

- (void)setClassID:(NSString *)classID
{
    _classID = classID;
}


- (void)setClassModels:(NSArray *)classModels
{
    _classModels = classModels;
    
    NSInteger count = classModels.count;
    CGFloat leftMargin = 15;
    CGFloat midMargin = 50;
    
    CGFloat allTextW = 0;
    for (LOLNewsClassModel *classModel in classModels) {
        CGFloat textW = [LOLBaseMethod LabelWidthOfString:classModel.name withFont:FONTSIZE(15) withHeight:MAXFLOAT];
        allTextW += textW;
    }
    CGFloat colletW = [LOLBaseMethod LabelWidthOfString:@"收藏" withFont:FONTSIZE(15) withHeight:MAXFLOAT];
    CGFloat scrollW = leftMargin*2+count*midMargin+allTextW+colletW;
    _classScrollView.contentSize = CGSizeMake(scrollW, 0);
    
    [_classScrollView jp_removeAllSubViews];
    [_buttonArray removeAllObjects];
    [_classScrollView addSubview:_lineImageView];
    CGFloat classBtnMaxX = leftMargin;
    for (NSInteger i = 0; i < count+1; i++) {
        if (i < count) {
            LOLNewsClassModel *model = [classModels objectAtIndex:i];
            UIButton *classBtn = [[UIButton alloc]init];
            [_classScrollView addSubview:classBtn];
            [classBtn setTitle:model.name forState:UIControlStateNormal];
            [classBtn.titleLabel setFont:FONTSIZE(15)];
            [classBtn setTitleColor:[UIColor jp_colorWithHexString:@"1f1f1f"] forState:UIControlStateNormal];
            [classBtn setTitleColor:DefaultGodColor forState:UIControlStateSelected];
            classBtn.tag = CLASSBTN_TAG+i;
            [classBtn addTarget:self action:@selector(clickClassBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat btnW = [LOLBaseMethod LabelWidthOfString:model.name withFont:FONTSIZE(15) withHeight:MAXFLOAT];
            CGFloat btnX = classBtnMaxX;
            classBtn.frame = CGRectMake(btnX, 15, btnW, 15);
            classBtnMaxX = CGRectGetMaxX(classBtn.frame)+midMargin;
            [_buttonArray addObject:classBtn];
            if ([model.id isEqualToString:self.classID]) {
                _preSelectBtn = classBtn;
                classBtn.selected = YES;
            }
        }else{
            if (count) {
                UIButton *colletBtn = [[UIButton alloc]init];
                [_classScrollView addSubview:colletBtn];
                [colletBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [colletBtn.titleLabel setFont:FONTSIZE(15)];
                [colletBtn setTitleColor:[UIColor jp_colorWithHexString:@"1f1f1f"] forState:UIControlStateNormal];
                [colletBtn setTitleColor:DefaultGodColor forState:UIControlStateSelected];
                colletBtn.tag = CLASSBTN_TAG+count;
                [colletBtn addTarget:self action:@selector(clickClassBtn:) forControlEvents:UIControlEventTouchUpInside];
                colletBtn.frame = CGRectMake(scrollW - leftMargin - colletW, 15, colletW, 15);
                [_buttonArray addObject:colletBtn];
            }
        }
    }
    _lineImageView.jp_x = _preSelectBtn.jp_x-KMARGIN*0.5;
    _lineImageView.jp_w = _preSelectBtn.jp_w+KMARGIN;
    _lineImageView.jp_y = CGRectGetMaxY(_preSelectBtn.frame)+KMARGIN*0.5;
    _lineImageView.jp_h = KMARGIN*0.5;
}

#pragma mark - 点击btn
- (void)clickClassBtn:(UIButton *)classBtn{
    
    if ([classBtn isEqual:_preSelectBtn]) {
        classBtn.selected = YES;
    }else{
        classBtn.selected = YES;
        _preSelectBtn.selected = NO;
    }
    [UIView animateWithDuration:0.1 animations:^{
        _lineImageView.jp_x = classBtn.jp_x-KMARGIN*0.5;
        _lineImageView.jp_w = classBtn.jp_w+KMARGIN;
        _lineImageView.jp_y = CGRectGetMaxY(classBtn.frame)+KMARGIN*0.5;
        _lineImageView.jp_h = KMARGIN*0.5;
        [self scrollPageBar:classBtn];
    }];
    _preSelectBtn = classBtn;
    
    //点击调用代理 刷新主页
    LOLNewsClassModel *classModel;
    NSInteger btnTag = classBtn.tag - CLASSBTN_TAG;
    if (btnTag < _classModels.count) {
        classModel = [_classModels objectAtIndex:btnTag];
    }else{
        classModel = [[LOLNewsClassModel alloc]init];
        classModel.name = @"收藏";
    }
    if ([self.delegate respondsToSelector:@selector(didSelectNoamalClassBtnWithView:classModel:index:)]) {
        [self.delegate didSelectNoamalClassBtnWithView:self classModel:classModel index:btnTag];
    }
}

-(void)scrollPageBar:(UIButton *)btn{
    
    CGFloat btnCenter = btn.center.x;
    CGFloat scrollToX = btnCenter - KWIDTH/2;
    if (scrollToX>0&&scrollToX<_classScrollView.contentSize.width-KWIDTH) {
        [_classScrollView setContentOffset:CGPointMake(scrollToX, 0) animated:true];
    }
    if (scrollToX>_classScrollView.contentSize.width-KWIDTH) {
        [_classScrollView setContentOffset:CGPointMake(_classScrollView.contentSize.width-KWIDTH, 0) animated:true];
    }
    if (scrollToX<0) {
        [_classScrollView setContentOffset:CGPointMake(0, 0) animated:true];
        
    }
}


@end
