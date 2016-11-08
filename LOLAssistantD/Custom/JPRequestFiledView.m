//
//  RequestFiledView.m
//  360
//
//  Created by tztddong on 16/4/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPRequestFiledView.h"

//默认的title
static NSString *noneDataText = @"暂无数据";
static NSString *filedNetText = @"网络异常,点击屏幕重新加载";
//默认的图片名
static NSString *noneDataImageName = @"D_zanwushuju-";
static NSString *filedNetImageName = @"D_wuwangluo";
//导航栏的高度
static CGFloat kNavH = 64;
//图片的宽高
static CGFloat kImageW = 78;
static CGFloat kImageH = 78;

@interface JPRequestFiledView ()

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)selectBlock selectBlock;

@end

@implementation JPRequestFiledView

+ (instancetype)configViewWithFrame:(CGRect)frame Type:(NSInteger)type selectBlock:(selectBlock)selectBlock{
    
    return [[[self class]alloc]initViewWithFrame:frame Title:nil ImageName:nil Type:type selectBlock:selectBlock];
}

+ (instancetype)configViewWithFrame:(CGRect)frame Title:(NSString *)title Type:(NSInteger)type selectBlock:(selectBlock)selectBlock{
    
    return [[[self class]alloc]initViewWithFrame:frame Title:title ImageName:nil Type:type selectBlock:selectBlock];
}

+ (instancetype)configViewWithFrame:(CGRect)frame ImageName:(NSString *)imageName Type:(NSInteger)type selectBlock:(selectBlock)selectBlock{
    
    return [[[self class]alloc]initViewWithFrame:frame Title:nil ImageName:imageName Type:type selectBlock:selectBlock];
}

+ (instancetype)configViewWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString *)imageName Type:(NSInteger)type selectBlock:(selectBlock)selectBlock{

    return [[[self class]alloc]initViewWithFrame:frame Title:title ImageName:imageName Type:type selectBlock:selectBlock];
}

- (instancetype)initViewWithFrame:(CGRect)frame
                            Title:(NSString *)title
                        ImageName:(NSString *)imageName
                             Type:(NSInteger)type
                      selectBlock:(selectBlock)selectBlock;{
    
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.title = title;
        self.imageName = imageName;
        self.type = type;
        self.selectBlock = selectBlock;
        [self addViews];
    }
    
    return self;
}

- (void)addViews{
    
    CGFloat kWidth = self.frame.size.width; 
    CGFloat kHeight = self.frame.size.height;
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageW, kImageH)];
    CGPoint imageCenter = CGPointMake(kWidth/2, kHeight/2-(imageV.frame.size.height/2+kNavH)/2);
    imageV.center = imageCenter;
    [self addSubview:imageV];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame),kWidth, 30)];
    [self addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.title == nil) {
        if (self.type == 1) {
            label.text = noneDataText;
        }else{
            label.text = filedNetText;
        }
    }else{
        label.text = self.title;
    }
    
    if (self.imageName == nil) {
        if (self.type == 1) {
            imageV.image = [UIImage imageNamed:noneDataImageName];
        }else{
            imageV.image = [UIImage imageNamed:filedNetImageName];
        }
    }else{
        imageV.image = [UIImage imageNamed:self.imageName];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.type == 2) {
    
        if (self.selectBlock) {
            self.selectBlock();
        }
    }else{
        return;
    }

}

@end
