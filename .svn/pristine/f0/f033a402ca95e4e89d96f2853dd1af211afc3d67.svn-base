//
//  BaseTableViewController.m
//  BaseProduct
//
//  Created by yj on 16/1/20.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseModel.h"

@interface BaseTableViewController ()

/** 无数据时显示的view */
@property (strong, nonatomic) UIView *noDataView;

@property (assign, nonatomic) BOOL isMore; ///< 是否还有更多数据

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.existCount = 0;
    refreshStatus = refreshType_Normal;
    self.showFooterView = YES;
    self.dataList = [NSMutableArray array];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.backgroundView = nil;
    
    //设置默认加载条数
    perPageCount = 15;
    //开始加载数据页码
    self.startPage = 1;
    
    //判断当前数量
    @weakify(self);
    [RACObserve(self, receiveCount) subscribeNext:^(NSNumber *value) {
        @strongify(self);
        if([value integerValue] < perPageCount){
            //没有更多
            [self removeRefreshFooter];
        }
        else if ([value integerValue] == perPageCount && [value integerValue]>0){
            [self configureRefreshFooter:self.header.scrollView];
            self.startPage ++;
            self.isMore = YES;
            _footer.hidden = NO;
        }
    }];
}

- (void)configureRefreshHeader:(UIScrollView *)tableView
{
    if(!_header)
    {
        @weakify(self);
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            // 进入刷新状态后会自动调用这个block
            refreshStatus = refreshType_PullDown;
            [self refreshData];
        }];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        _header.lastUpdatedTimeLabel.hidden = YES;
        tableView.mj_header = _header;
    }
}

- (void)configureRefreshFooter:(UIScrollView *)tableView
{
    if(!_footer && self.showFooterView){
        @weakify(self);
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            // 进入刷新状态后会自动调用这个block
            refreshStatus = refreshType_PullUp;
            [self refreshData];
        }];
        tableView.mj_footer = _footer;
    }
}

- (void)removeRefreshFooter
{
    self.isMore = NO;
    _footer.hidden = YES;
}

//刷新数据
- (void)refreshData
{
    switch (refreshStatus) {
        case refreshType_Normal:
            self.startPage = 1;
            break;
        case refreshType_PullDown:
            self.startPage = 1;
            self.existCount = 0;
            break;
        case refreshType_PullUp:
            break;
        default:
            break;
    }
}

- (void)beginDataRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_header beginRefreshing];
    });
}

- (void)endDataRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        refreshStatus = refreshType_Normal;
        [_footer endRefreshing];
        [_header endRefreshing];
        
        if (!self.isMore) {
            [_footer endRefreshingWithNoMoreData];
        }
    });
}

- (NSArray *)noDuplicateListWithadditionList:(NSArray *)addition
{
    //接收到的数据
    self.receiveCount = [addition count];
    
    @autoreleasepool {
        
        NSMutableSet *sourceSet             = [[NSMutableSet alloc] init];
        NSMutableSet *additionSet           = [[NSMutableSet alloc] init];
        NSMutableDictionary *additionMap    = [[NSMutableDictionary alloc] init];
        for (BaseModel *aBrief in self.dataList) {
            [sourceSet addObject:aBrief.bid];
        }
        for (BaseModel *aBrief in addition) {
            [additionSet addObject:aBrief.bid];
            [additionMap setObject:aBrief forKey:aBrief.bid];
        }
        
        [additionSet intersectSet:sourceSet];
        NSMutableArray *result = [NSMutableArray arrayWithArray:addition];
        for (NSObject *key in additionSet) {
            NSObject *obj = [additionMap objectForKey:key];
            [result removeObject:obj];
        }
        
        //去重后的数据
        self.existCount += [result count];
        
        return result;
    }
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
        self.noDataView.center = CGPointMake(self.noDataView.center.x, CGRectGetHeight(self.tableView.frame) * 0.4);
        
        [self.tableView addSubview:self.noDataView];
    }
    self.noDataView.hidden = NO;
}

- (void)hidenoDataView
{
    self.noDataView.hidden = YES;
}

- (void)dotoOperate:(UIButton *)button
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button.currentTitle);
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dealloc
{
    NSLog(@"table正常释放dealloc:%@",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
