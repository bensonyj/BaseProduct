//
//  BaseViewController.m
//  BaseProduct
//
//  Created by yj on 16/1/19.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "FeHourGlass.h"

@interface BaseViewController ()
{
    FeHourGlass *loadingView;
}

@property (nonatomic, strong) UIView *notNetView;

/** 无数据时显示的view */
@property (strong, nonatomic) UIView *noDataView;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.00){
        topHeight = 64;
    }
    else{
        topHeight = 0;
    }
    
    //设置主背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置左滑手势滑动范围
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 100;

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //去掉导航栏边线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self customBackBarButtonItem];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    loadingView = nil;
    NSLog(@"正常释放dealloc:%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%@--%@-didReceiveMemoryWarning", self.title,self.navigationItem.title);
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    //清除所有的内存中图片缓存，不影响正在显示的图片
    [[SDImageCache sharedImageCache] clearMemory];
    //停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}

- (void)customBackBarButtonItem
{
    UIImage *image = [UIImage imageNamed:@"icon_arrow_back"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
}

- (void)backBarButtonItemClick:(UIBarButtonItem *)barItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)createBarItemWithImage:(NSString *)imageName {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageRight = [UIImage imageNamed:imageName];
    rightButton.frame = CGRectMake(0, 0, 30, imageRight.size.height);
    [rightButton setImage:imageRight forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    return [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (UIButton *)createBarItemButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:RGB(204, 204, 204) forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    return button;
}

#pragma mark - 空白页面加载数据视图

- (void)showDataLoadingView
{
    loadingView = [[FeHourGlass alloc] initWithView:self.view anmationColor:nil];
    [self.view addSubview:loadingView];
    
    [loadingView show];
}

- (void)dismissDataLoadingView
{
    [loadingView dismiss];
}

#pragma mark - 内容为空处理

- (void)noDataShowImage:(NSString *)imageName tipsArray:(NSArray *)tipsArray buttonTitleArray:(NSArray *)titleArray;
{
    if (!self.noDataView) {
        self.noDataView = [[UIView alloc] init];
        //        self.noDataView.backgroundColor = COLOR_Z;
        
        CGFloat top = 0;
        if (imageName) {
            UIImage *image = [UIImage imageNamed:imageName];
            
            CGFloat width = image.size.width / 2;
            CGFloat height = image.size.height / 2;
            //icon
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2.0, top, width, height)];
            imageView.image = image;
            [self.noDataView addSubview:imageView];
            
            top = CGRectGetMaxY(imageView.frame) + 12;
        }
        
        //tips
        for (int i = 0; i < tipsArray.count; i++) {
            UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 12)];
            //            tipsLabel.backgroundColor = COLOR_Z;
            //            tipsLabel.textColor = COLOR_E;
            tipsLabel.font = [UIFont systemFontOfSize:13.0f];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.text = tipsArray[i];
            [self.noDataView addSubview:tipsLabel];
            
            top = CGRectGetMaxY(tipsLabel.frame) + 7;
        }
        
        //button
        if ([titleArray count] > 0) {
            
            //计算最长title的长度
            CGFloat buttonWidth = 0;
            for (NSString *title in titleArray) {
                CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:13.0f] byHeight:15];
                if (size.width > buttonWidth) {
                    buttonWidth = size.width;
                }
            }
            
            //扩大点击范围
            buttonWidth += 10 + 10;
            //计算第一个button的起始位置
            CGFloat buttonX = (SCREEN_WIDTH - buttonWidth*titleArray.count) / 2.0;
            
            for (int i = 0; i < titleArray.count; i++) {
                NSString *title = titleArray[i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(buttonX, top, buttonWidth, 15);
                [button setTitle:title forState:UIControlStateNormal];
                //                [button setTitleColor:COLOR_CB1 forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [button addTarget:self action:@selector(dotoOperate:) forControlEvents:UIControlEventTouchUpInside];
                [self.noDataView addSubview:button];
                
                buttonX += buttonWidth + 1;
                //当button大于1个且不是最后一个时添加竖线
                if (i < (titleArray.count - 1)) {
                    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonX + 0.5, top + 2, 0.5, 10)];
                    //                    lineLabel.backgroundColor = COLOR_E;
                    [self.noDataView addSubview:lineLabel];
                }
            }
            
            top += 15 + 4;
        }
        
        self.noDataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, top);
        self.noDataView.center = CGPointMake(self.view.center.x, CGRectGetHeight(self.view.frame) * 0.4);
        
        [self.view addSubview:self.noDataView];
        [self.view bringSubviewToFront:self.noDataView];
    }
    self.noDataView.hidden = NO;
}

- (void)hideNoDataView
{
    if (self.noDataView) {
        self.noDataView.hidden = YES;
        [self.noDataView removeFromSuperview];
    }
    self.noDataView = nil;
}

#pragma mark - 无网络

- (void)showNotNetView
{
    [self.view addSubview:self.notNetView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-wifi"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_notNetView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_notNetView);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = _notNetView.backgroundColor;
    tipLabel.text = @"网络不太顺畅喔~";
    tipLabel.font = [UIFont boldSystemFontOfSize:17.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor darkGrayColor];
    [_notNetView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_notNetView.mas_left).offset(0);
        make.right.equalTo(_notNetView.mas_right).offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"重新加载" forState:0];
    [button setTitleColor:[UIColor darkGrayColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.layer.cornerRadius = 5.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [button addTarget:self action:@selector(dotoOperate:) forControlEvents:UIControlEventTouchUpInside] ;
    [_notNetView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.centerX.equalTo(_notNetView.mas_centerX);
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
    }];
}

- (void)dismissNotNetView
{
    if (self.notNetView) {
        self.notNetView.hidden = YES;
        [self.notNetView removeFromSuperview];
    }
    self.notNetView = nil;
}

- (UIView *)notNetView
{
    if (!_notNetView) {
        _notNetView = [[UIView alloc] initWithFrame:self.view.bounds];
        _notNetView.backgroundColor = self.view.backgroundColor;
    }
    return  _notNetView;
}

#pragma mark - BaseViewController 按钮事件

- (void)dotoOperate:(UIButton *)button
{
    if (self.buttonClick) {
        self.buttonClick(button.currentTitle);
    }
}

#pragma mark - 获取数据
- (void)refreshData
{
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

@end
