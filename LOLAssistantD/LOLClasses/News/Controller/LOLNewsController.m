 //
//  LOLNewsController.m
//  LOL Helper
//
//  Created by tztddong on 16/10/9.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLNewsController.h"
#import "JPLoopView.h"
#import "LOLNewsScrollCellModel.h"
#import "LOLNewsNormalClassView.h"
#import "LOLNewsClassModel.h"
#import "LOLNewsListCell.h"
#import "LOLNewsSpecialClassCell.h"
#import "LOLNewsCellModel.h"
#import "LOLNewsImagesCell.h"
#import "LOLNewsDetailController.h"

static NSString *newsCell = @"newsCell";

@interface LOLNewsController ()<UITableViewDelegate,UITableViewDataSource,JPLoopViewDelegate,JPLoopViewDataSource,LOLNewsNormalClassViewDeleagte,LOLNewsSpecialClassCellDeleagte>

@end

@implementation LOLNewsController
{
    UIButton                *_headIconBtn;
    UIButton                *_searchBtn;
    UITableView             *_newsTableView;
    UIView                  *_headerView;
    UIButton                *_backBtn;
    UILabel                 *_titleNameLab;
    JPLoopView              *_loopView;
    UIView                  *_alphaView;
    CGFloat                 _topHeadVIewH;
    NSArray                 *_scrollImageArray;
    NSMutableArray          *_scrollImageUrls;
    LOLNewsNormalClassView  *_newsNormalClassView;
    NSString                *_classID;
    NSString                *_defaultClassID;
    NSMutableArray          *_newsListArray;
    NSMutableArray          *_newsNormalClassModels;
    NSMutableArray          *_newsSpecialClassModels;
    BOOL                    _isHiddenSpecialClassView;
    UIPanGestureRecognizer  *_tableViewPan;
    UIView                  *_refreshView_Header;
    UIImageView             *_refreshImage_Header;
    UILabel                 *_refreshLabel_Header;
    UIView                  *_refreshView_Footer;
    UIImageView             *_refreshImage_Footer;
    UILabel                 *_refreshLabel_Footer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topHeadVIewH = self.view.jp_w*IMAGE_SCALE+KDefaultCellH;
    _scrollImageUrls = [NSMutableArray array];
    _newsNormalClassModels = [NSMutableArray array];
    _newsSpecialClassModels = [NSMutableArray array];
    _newsListArray = [NSMutableArray array];
    
    [self creatTableView];
    [self creatHeaderView];
    [self configRefresh];
    [self requestScrollImageData];
    [self requestClassData];
    
}

#pragma mark - creat headerview
- (void)creatHeaderView{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.jp_w, _topHeadVIewH)];
    [self.view addSubview:_headerView];
    
    _loopView = [[JPLoopView alloc]initWithFrame:CGRectMake(0, 0, self.view.jp_w, self.view.jp_w*IMAGE_SCALE)];
    _loopView.dataSource = self;
    _loopView.delegate = self;
    [_headerView addSubview:_loopView];
    
    _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _headerView.jp_w, KNAVHEIGHT)];
    _alphaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_bg_for_seven"]];
    _alphaView.alpha = 0.0;
    [self.view addSubview:_alphaView];
    
    _newsNormalClassView = [[LOLNewsNormalClassView alloc]initWithFrame:CGRectMake(0,_loopView.jp_h, KWIDTH, KDefaultCellH)];
    _newsNormalClassView.delegate = self;
    [_headerView addSubview:_newsNormalClassView];

    _headIconBtn = [[UIButton alloc]init];
    _headIconBtn.layer.cornerRadius = 17;
    _headIconBtn.layer.borderWidth = 2;
    _headIconBtn.layer.borderColor = DefaultGodColor.CGColor;
    _headIconBtn.frame = CGRectMake(KMARGIN, 2*KMARGIN+2, 34, 34);
    [self.view addSubview:_headIconBtn];
    
    _searchBtn = [[UIButton alloc]init];
    [_searchBtn setImage:[UIImage imageNamed:@"news_search"] forState:UIControlStateNormal];
    [_searchBtn setImage:[UIImage imageNamed:@"news_search_hl"] forState:UIControlStateHighlighted];
    _searchBtn.layer.cornerRadius = 17;
    _searchBtn.frame = CGRectMake(self.view.jp_w - KMARGIN - 34, 2*KMARGIN+2, 34, 34);
    [self.view addSubview:_searchBtn];
    
    _titleNameLab = [[UILabel alloc]init];
    _titleNameLab.text = @"英雄联盟";
    _titleNameLab.textColor = DefaultGodColor;
    _titleNameLab.font = [UIFont systemFontOfSize:18];
    [_titleNameLab sizeToFit];
    _titleNameLab.jp_centerX = _headerView.jp_w/2.0;
    _titleNameLab.jp_centerY = _headIconBtn.jp_centerY;
    _titleNameLab.hidden = YES;
    [self.view insertSubview:_titleNameLab aboveSubview:_alphaView];
}


#pragma mark - creat UITableView
- (void)creatTableView{
    
    _newsTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    [_newsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:newsCell];
    //设置滚动范围
    _newsTableView.contentInset = UIEdgeInsetsMake(_topHeadVIewH, 0, KTABBARHEIGHT, 0);
    _newsTableView.scrollIndicatorInsets = _newsTableView.contentInset;
    _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _newsTableView.backgroundColor = [UIColor jp_colorWithHexString:@"eeeff0"];
    [_newsTableView registerClass:[LOLNewsListCell class] forCellReuseIdentifier:@"LOLNewsListCell"];
    [_newsTableView registerClass:[LOLNewsSpecialClassCell class] forCellReuseIdentifier:@"LOLNewsSpecialClassCell"];
    [_newsTableView registerClass:[LOLNewsImagesCell class] forCellReuseIdentifier:@"LOLNewsImagesCell"];
    [_newsTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _tableViewPan = _newsTableView.panGestureRecognizer;
    [_tableViewPan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_newsTableView];
}

#pragma mark - refresh
- (void)configRefresh{
    
    _refreshView_Header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.jp_w, KNAVHEIGHT)];
    _refreshView_Header.backgroundColor = [UIColor jp_colorWithHexString:@"eeeff0"];
    [self.view insertSubview:_refreshView_Header belowSubview:_headerView];
    
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 1; i < 9; i++) {
        NSString *imageName = [NSString stringWithFormat:@"personal_refresh_loading2%zd",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    CGFloat imageW = 27;
    CGFloat imageH = 30;
    _refreshImage_Header = [[UIImageView alloc]initWithFrame:CGRectMake((_refreshView_Header.jp_w - imageW)/2.0, (KDefaultCellH-imageH)/2.0+5, imageW, imageH)];
    _refreshImage_Header.animationImages = images.copy;
    _refreshImage_Header.animationDuration = 0.5;
    _refreshImage_Header.animationRepeatCount = 0;
    _refreshImage_Header.image = [images firstObject];
    [_refreshView_Header addSubview:_refreshImage_Header];
    
    _refreshLabel_Header = [[UILabel alloc]initWithFrame:CGRectMake(0, KDefaultCellH, self.view.jp_w, KNAVHEIGHT-KDefaultCellH)];
    _refreshLabel_Header.text = @"下拉刷新";
    _refreshLabel_Header.font = FONTSIZE(13);
    _refreshLabel_Header.textAlignment = NSTextAlignmentCenter;
    _refreshLabel_Header.textColor = [UIColor jp_colorWithHexString:@"9e9fa0"];
    [_refreshView_Header addSubview:_refreshLabel_Header];
    
    _refreshView_Footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.jp_h-KTABBARHEIGHT, self.view.jp_w, KNAVHEIGHT)];
    _refreshView_Footer.backgroundColor = [UIColor jp_colorWithHexString:@"eeeff0"];
    [self.view addSubview:_refreshView_Footer];
    

    _refreshImage_Footer = [[UIImageView alloc]initWithFrame:CGRectMake((_refreshView_Header.jp_w - imageW)/2.0, (KDefaultCellH-imageH)/2.0, imageW, imageH)];
    _refreshImage_Footer.animationImages = images.copy;
    _refreshImage_Footer.animationDuration = 0.5;
    _refreshImage_Footer.animationRepeatCount = 0;
    _refreshImage_Footer.image = [images firstObject];
    [_refreshView_Footer addSubview:_refreshImage_Footer];
    
    _refreshLabel_Footer = [[UILabel alloc]initWithFrame:CGRectMake(0, KDefaultCellH-5, self.view.jp_w, KNAVHEIGHT-KDefaultCellH)];
    _refreshLabel_Footer.text = @"上拉加载更多";
    _refreshLabel_Footer.font = FONTSIZE(13);
    _refreshLabel_Footer.textAlignment = NSTextAlignmentCenter;
    _refreshLabel_Footer.textColor = [UIColor jp_colorWithHexString:@"9e9fa0"];
    [_refreshView_Footer addSubview:_refreshLabel_Footer];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isHiddenSpecialClassView ? _newsListArray.count : _newsListArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOLNewsCellModel *newsModel;
    if (!_isHiddenSpecialClassView) {//需要特殊的class
        if (indexPath.row == 0) {
            LOLNewsSpecialClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOLNewsSpecialClassCell"];
            cell.classModels = _newsSpecialClassModels;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        newsModel = [_newsListArray objectAtIndex:indexPath.row-1];
    }else{
        newsModel = [_newsListArray objectAtIndex:indexPath.row];
    }
    if ([newsModel.newstype isEqualToString:@"图集"]) {
        LOLNewsImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOLNewsImagesCell"];
        cell.newsModel = newsModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    LOLNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOLNewsListCell"];
    cell.newsModel = newsModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOLNewsCellModel *newsModel;
    if (!_isHiddenSpecialClassView) {//需要特殊的class
        if (indexPath.row == 0) {
            CGFloat row = (_newsSpecialClassModels.count-1)/2+1;
            return row*45+KMARGIN;
        }
        newsModel = [_newsListArray objectAtIndex:indexPath.row-1];
    }else{
        newsModel = [_newsListArray objectAtIndex:indexPath.row];
    }
    if ([newsModel.newstype isEqualToString:@"图集"]) {
        return 210;
    }

    return 92.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转
    LOLNewsCellModel *newsModel;
    if (!_isHiddenSpecialClassView) {//需要特殊的class
        newsModel = [_newsListArray objectAtIndex:indexPath.row-1];
    }else{
        newsModel = [_newsListArray objectAtIndex:indexPath.row];
    }
    
    LOLNewsDetailController *detailVC = [[LOLNewsDetailController alloc]init];
    detailVC.url = newsModel.article_url;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark KVO监听 contentoffset / state
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        //手动设置了滚动范围 需要加上
        CGFloat offset = contentOffset.y + _topHeadVIewH;
        
        //offset 正--向上滚动   负--向下滚动
        //headerView滚动的最小Y值
        CGFloat kHeaderMinY = _topHeadVIewH-KNAVHEIGHT-KDefaultCellH;
        
        //哪个值小 取当值的负数便是Y值
        _headerView.jp_y = -MIN(offset, kHeaderMinY);
        CGFloat progress = 1 - offset/kHeaderMinY;
        
        //返回按钮 标题 的显示与否
        _titleNameLab.hidden = progress > 0;
        
        _alphaView.alpha = progress > 0 ? 0 : 1.0;
        
        _headIconBtn.hidden = _searchBtn.hidden = offset < -1.0;
        
        //下拉刷新的逻辑
        if (offset < -64.5) {
            _refreshLabel_Header.text = @"释放刷新";
        }else if(offset > -64){
            _refreshLabel_Header.text = @"下拉刷新";
        }else{
            _refreshLabel_Header.text = @"刷新中";
        }
        
        //上啦刷新的逻辑
        CGFloat footoffset = contentOffset.y+self.view.jp_h-KTABBARHEIGHT - _newsTableView.contentSize.height;
        
        _refreshView_Footer.jp_y = self.view.jp_h-KTABBARHEIGHT-footoffset;
        if (footoffset > 0 && footoffset < KNAVHEIGHT) {
            _refreshLabel_Footer.text = @"上拉加载更多";
        }else if (footoffset > KNAVHEIGHT){
            _refreshLabel_Footer.text = @"释放加载";
        }else{
            _refreshLabel_Footer.text = @"加载中";
        }
    }else if ([keyPath isEqualToString:@"state"]){
        
        UIPanGestureRecognizer *tableViewPan = (UIPanGestureRecognizer *)object;
        if (tableViewPan.state == UIGestureRecognizerStateEnded && _newsTableView.contentOffset.y < -(KNAVHEIGHT + _topHeadVIewH)) {
            NSLog(@"开始下拉");
            [self beginRefresh_Header];
        }
        if (tableViewPan.state == UIGestureRecognizerStateEnded && _newsTableView.contentOffset.y+self.view.jp_h-KTABBARHEIGHT - _newsTableView.contentSize.height > KNAVHEIGHT) {
            NSLog(@"开始上拉");
            [self beginRefresh_Footer];
        }
        
    }
}

- (void)beginRefresh_Header{
    
    if ([_refreshImage_Header isAnimating]) {
        return;
    }
    [_refreshImage_Header startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _newsTableView.contentInset = UIEdgeInsetsMake(_topHeadVIewH+KNAVHEIGHT, 0, KTABBARHEIGHT, 0);
        [self requestScrollImageData];
        [self requestNewsList];
    }];
}

- (void)endRefresh_Header{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_refreshImage_Header stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            _newsTableView.contentInset = UIEdgeInsetsMake(_topHeadVIewH, 0, KTABBARHEIGHT, 0);
        }];
    });
}

- (void)beginRefresh_Footer{
    
    if ([_refreshImage_Footer isAnimating]) {
        return;
    }
    [_refreshImage_Footer startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _newsTableView.contentInset = UIEdgeInsetsMake(_topHeadVIewH, 0, KTABBARHEIGHT+KNAVHEIGHT, 0);
        //加载更多
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefresh_Footer];
    });
}

- (void)endRefresh_Footer{
    
    [_refreshImage_Footer stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _newsTableView.contentInset = UIEdgeInsetsMake(_topHeadVIewH, 0, KTABBARHEIGHT, 0);
    }];
}


#pragma mark - request
- (void)requestScrollImageData
{
    [LOLRequest getWithUrl:LOL_URL_SCROLLIMAGE params:nil success:^(id responseObject) {
        NSArray *list = [responseObject objectForKey:@"list"];
        if (list.count) {
            _scrollImageArray = [LOLNewsScrollCellModel mj_objectArrayWithKeyValuesArray:list];
            [_scrollImageUrls removeAllObjects];
            for (LOLNewsScrollCellModel *model in _scrollImageArray) {
                [_scrollImageUrls addObject:model.image_url_big];
            }
            [_loopView jp_reloadData];
        }

    } failure:^(NSError *error) {
        [self.view makeToast:@"requestNewsData请求出错"];
    }];
    
}

#pragma mark - JPLoopView的代理
- (NSArray *)loopViewUrls:(JPLoopView *)loopView{
    
    return _scrollImageUrls;
}

- (BOOL)scrollImage:(JPLoopView *)loopView{
    
    return NO;
}

- (void)didSelectItem:(JPLoopView *)loopView index:(NSInteger)index{
 
    LOLNewsDetailController *detailVC = [[LOLNewsDetailController alloc]init];
    LOLNewsScrollCellModel *model = _scrollImageArray[index];
    if ([model.article_url hasPrefix:@"http"]) {
        detailVC.url = model.article_url;
    }else{
        detailVC.url = [NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/%@?APP_BROWSER_VERSION_CODE=1&ios_version=1005&imgmode=auto",model.article_url];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - class_list
- (void)requestClassData{
    
    [LOLRequest getWithUrl:LOL_CLASS params:nil success:^(id responseObject) {
        NSArray *classModels = [LOLNewsClassModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (classModels.count) {
            [_newsNormalClassModels removeAllObjects];
            [_newsSpecialClassModels removeAllObjects];
            for (LOLNewsClassModel *classModel in classModels) {
                BOOL is_entry = [classModel.is_entry boolValue];
                if (is_entry) {
                    [_newsSpecialClassModels addObject:classModel];
                }else{
                    [_newsNormalClassModels addObject:classModel];
                }
            }
            _defaultClassID = [[_newsNormalClassModels firstObject] id];
            _newsNormalClassView.classID = _defaultClassID;
            _newsNormalClassView.classModels = _newsNormalClassModels;
            if (_classID.length && ![_classID isEqualToString:_defaultClassID]) {
                _isHiddenSpecialClassView = YES;
            }else{
                _isHiddenSpecialClassView = !_newsSpecialClassModels.count;
            }
            [self requestNewsList];
        }else{
            [self noneData];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"requestClass请求出错"];
    }];
}

#pragma mark - news_list
- (void)requestNewsList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_classID.length ? _classID : _defaultClassID forKey:@"id"];
    [params setObject:@0 forKey:@"page"];
    [params setObject:@"ios" forKey:@"plat"];
    [params setObject:@33 forKey:@"version"];
    
    [LOLRequest getWithUrl:LOL_URL_NEWSLIST params:params success:^(id responseObject) {
        NSArray *list = [responseObject objectForKey:@"list"];
        [_newsListArray removeAllObjects];
        if (list.count) {
            [_newsListArray addObjectsFromArray:[LOLNewsCellModel mj_objectArrayWithKeyValuesArray:list]];
//            [_newsTableView reloadData];
            [UIView performWithoutAnimation:^{
                [_newsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
            }];
        }else{
            [self noneData];
        }
        [self endRefresh_Header];
    } failure:^(NSError *error) {
        [self.view makeToast:@"requestNewsList请求出错"];
        [self endRefresh_Header];
    }];
}


#pragma mark 代理
- (void)didSelectSpecialClassBtnWithView:(LOLNewsSpecialClassCell *)specialClassView classModel:(LOLNewsClassModel *)classModel
{
    NSLog(@"select-- %@",classModel.name);
    if (classModel.url.length) {
        LOLNewsDetailController *detailVC = [[LOLNewsDetailController alloc]init];
        detailVC.url = classModel.url;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
    }
}

- (void)didSelectNoamalClassBtnWithView:(LOLNewsNormalClassView *)noamalClassView classModel:(LOLNewsClassModel *)classModel index:(NSInteger)index
{
    NSLog(@"%zd",index);
    if ([classModel.name isEqualToString:@"收藏"]) {
        return;
    }
    _classID = classModel.id;
    if ([_defaultClassID isEqualToString:_classID]) {
        _isHiddenSpecialClassView = NO;
    }else{
        _isHiddenSpecialClassView = YES;
    }
    [self requestNewsList];
}

@end
