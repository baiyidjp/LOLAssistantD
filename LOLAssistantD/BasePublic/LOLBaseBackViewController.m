//
//  LOLBaseBackViewController.m
//  LOLAssistantD
//
//  Created by tztddong on 2016/11/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLBaseBackViewController.h"
#import "LOLLeftSetBtn.h"

static NSString *cellID = @"infotable";

@interface LOLBaseBackViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LOLBaseBackViewController
{
    UIImageView         *_headerIcon;
    UILabel             *_nameLabel;
    UIButton            *_ageBtn;
    UIImageView         *_infoImage;
    UILabel             *_infoLabel;
    UIView              *_lineView;
    UITableView         *_infoTableView;
    UIImageView         *_setImage;
    UILabel             *_setLabel;
    LOLLeftSetBtn       *_leftSetBtn;
    NSMutableArray      *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configHeaderView];
    [self configTableView];
}

- (void)configHeaderView{
    
    _headerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(KMARGIN*3/2.0, 5*KMARGIN, 5*KMARGIN, 5*KMARGIN)];
    _headerIcon.layer.cornerRadius = 25;
    _headerIcon.layer.borderWidth = 2;
    _headerIcon.layer.borderColor = DefaultGodColor.CGColor;
    [self.view addSubview:_headerIcon];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"Keep丶Dream";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = FONTSIZE(13);
    [_nameLabel sizeToFit];
    _nameLabel.jp_x = _headerIcon.jp_x;
    _nameLabel.jp_y = _headerIcon.jp_y+_headerIcon.jp_h+KMARGIN*3/2.0;
    [self.view addSubview:_nameLabel];
    
    _ageBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+KMARGIN, _nameLabel.jp_y, 40, _nameLabel.jp_h)];
    [_ageBtn setImage:[UIImage imageNamed:@"friend_sex_male"] forState:UIControlStateNormal];
    [_ageBtn setTitle:@"25" forState:UIControlStateNormal];
    [_ageBtn.titleLabel setFont:FONTSIZE(12)];
    [_ageBtn setBackgroundColor:[UIColor jp_colorWithHexString:@"35c4cf"]];
    _ageBtn.layer.cornerRadius = 2;
    _ageBtn.layer.masksToBounds = YES;
    [self.view addSubview:_ageBtn];
    
    _infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.jp_centerX+2*KMARGIN, _headerIcon.jp_y, 32, 20)];
    _infoImage.image = [UIImage imageNamed:@"left_card"];
    [self.view addSubview:_infoImage];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_infoImage.jp_x, CGRectGetMaxY(_infoImage.frame)+KMARGIN/2, 50, 12)];
    _infoLabel.font = FONTSIZE(11);
    _infoLabel.text = @"我的名片";
    _infoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_infoLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.jp_x, CGRectGetMaxY(_nameLabel.frame)+35, KWIDTH*0.8, 1)];
    _lineView.backgroundColor = [UIColor jp_colorWithHexString:@"272727"];
    [self.view addSubview:_lineView];
    
    _leftSetBtn = [[LOLLeftSetBtn alloc] initWithFrame:CGRectMake(_nameLabel.jp_x, KHEIGHT-55, 70, 20)];
    [_leftSetBtn setImage:[UIImage imageNamed:@"left_setting"] forState:UIControlStateNormal];
    [_leftSetBtn setTitle:@"设置" forState:UIControlStateNormal];
    [_leftSetBtn.titleLabel setFont:FONTSIZE(20)];
    [_leftSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_leftSetBtn];
}

- (void)configTableView{
    
    _dataArray = [NSMutableArray array];
    NSDictionary *dict1 = @{@"title":@"我的动态",@"imageName":@"left_timeline"};
    NSDictionary *dict2 = @{@"title":@"我的下载",@"imageName":@"left_download"};
    NSDictionary *dict3 = @{@"title":@"我的订阅",@"imageName":@"left_subscibe"};
    NSDictionary *dict4 = @{@"title":@"我的收藏",@"imageName":@"left_collect"};
    [_dataArray addObject:dict1];
    [_dataArray addObject:dict2];
    [_dataArray addObject:dict3];
    [_dataArray addObject:dict4];
    
    CGFloat tableH = _dataArray.count*KDefaultCellH;
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.jp_h/2.0 - tableH/2.0, self.view.jp_w, tableH) style:UITableViewStylePlain];
    _infoTableView.dataSource = self;
    _infoTableView.delegate = self;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.backgroundColor = [UIColor clearColor];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_infoTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"imageName"]];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
