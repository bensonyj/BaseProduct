//
//  BaseViewController.m
//  BaseProduct
//
//  Created by yj on 16/1/19.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseViewController ()

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
