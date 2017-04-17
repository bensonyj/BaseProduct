//
//  BaseCollectionViewController.m
//  CattleAutoParts
//
//  Created by 应剑 on 16/8/10.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()

@property (assign, nonatomic) BOOL isMore; ///< 是否还有更多数据

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.existCount = 0;
    self.refreshStatus = refreshType_Normal;
//    self.showFooterView = YES;
//    self.dataList = [NSMutableArray array];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.collectionView.backgroundView = nil;
    
//    //设置默认加载条数
//    self.perPageCount = 15;
//    //开始加载数据页码
//    self.startPage = 1;
    
    //判断当前数量
    @weakify(self);
    [RACObserve(self, receiveCount) subscribeNext:^(NSNumber *value) {
        @strongify(self);
        if([value integerValue] < self.perPageCount){
            //没有更多
            [self removeRefreshFooter];
        }
        else if ([value integerValue] == self.perPageCount && [value integerValue]>0){
            if (self.showFooterView) {
                [self configureRefreshFooter:self.collectionView];
            }
        }
    }];
}

- (BOOL)showFooterView
{
    return YES;
}

- (NSInteger)startPage
{
    return 1;
}

- (NSInteger)perPageCount
{
    return 10;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)configureRefreshHeader:(UIScrollView *)collectionView
{
    collectionView.mj_header = self.header;
}

- (void)configureRefreshFooter:(UIScrollView *)collectionView
{
    self.startPage ++;
    self.isMore = YES;
    
    collectionView.mj_footer = self.footer;
    _footer.hidden = NO;
}

- (void)removeRefreshFooter
{
    self.isMore = NO;
    _footer.hidden = YES;
}

//刷新数据
- (void)refreshData
{
    [super refreshData];
    switch (_refreshStatus) {
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
        self.refreshStatus = refreshType_Normal;
        [_footer endRefreshing];
        [_header endRefreshing];
        
        if (!self.isMore) {
            [_footer endRefreshingWithNoMoreData];
        }
    });
}

- (MJRefreshNormalHeader *)header
{
    if(!_header)
    {
        @weakify(self);
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            // 进入刷新状态后会自动调用这个block
            self.refreshStatus = refreshType_PullDown;
            [self refreshData];
        }];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        _header.lastUpdatedTimeLabel.hidden = YES;
    }
    
    return _header;
}

- (MJRefreshAutoNormalFooter *)footer
{
    if(!_footer && self.showFooterView){
        @weakify(self);
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            // 进入刷新状态后会自动调用这个block
            self.refreshStatus = refreshType_PullUp;
            [self refreshData];
        }];
    }
    
    return _footer;
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
            if (aBrief.bid) {
                [sourceSet addObject:aBrief.bid];
            }
        }
        for (BaseModel *aBrief in addition) {
            if (aBrief.bid) {
                [additionSet addObject:aBrief.bid];
                [additionMap setObject:aBrief forKey:aBrief.bid];
            }
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

#pragma mark - UICollectionView

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        return layout.itemSize;
    }
    
    CGFloat width = ceilf((SCREEN_WIDTH - 15) / 2.0);
    CGFloat hieght = ceilf(240 * (width / 180.0));
    return CGSizeMake(width, hieght);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        return layout.sectionInset;
    }
    return UIEdgeInsetsMake(10, 5, 10, 0);
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - lazy

- (UICollectionViewFlowLayout *)setupFlowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self setupFlowLayout]];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.backgroundView = nil;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    return _collectionView;
}

#pragma mark - 点击空白处隐藏键盘

- (void)setupTapHiddenKeyboardGesture
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:gesture];
    @weakify(self);
    [gesture.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
}

#pragma mark - dealloc

- (void)dealloc
{
    NSLog(@"table正常释放dealloc:%@",NSStringFromClass([self class]));
}

@end
