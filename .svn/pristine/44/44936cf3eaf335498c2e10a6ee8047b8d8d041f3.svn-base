//
//  BaseTableViewController.h
//  BaseProduct
//
//  Created by yj on 16/1/20.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"

static NSString *CellIdentifier = @"CellIdentifier";



@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    RefreshType         refreshStatus;
    NSInteger           perPageCount;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
/** 当前视图数组 */
@property (nonatomic, strong) NSMutableArray *dataList;

/** 下拉刷新 */
@property (nonatomic, strong) MJRefreshNormalHeader *header;
/** 上拉加载 */
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

/** 接收到数据量 */
@property (nonatomic, assign) NSInteger receiveCount;
/** 当前存在的数据量 */
@property (nonatomic, assign) NSInteger existCount;

/** 分页加载起始页 */
@property (nonatomic, assign) NSInteger startPage;

/** 是否显示底部上拉加载更多控件，Default is YES  */
@property (nonatomic, assign) BOOL showFooterView;

/**
 *  @brief  添加下拉刷新控件
 */
- (void)configureRefreshHeader:(UIScrollView *)tableView;

/**
 *  @brief  添加上拉加载更多控件
 *
 */
- (void)configureRefreshFooter:(UIScrollView *)tableView;

/**
 *  @brief  移除下拉刷新、上拉控件
 */
- (void)removeRefreshFooter;

/**
 *  @brief  开始下拉刷新
 */
- (void)beginDataRefresh;

/**
 *  @brief  数据刷新结束
 */
- (void)endDataRefresh;

/**
 *  网络新获得的数组和已有数组做比较，返回去重的获得数组
 *
 *  @param addition 网络获得的数组
 *
 *  @return 去重的数组
 */
- (NSArray *)noDuplicateListWithadditionList:(NSArray *)addition;

/** 无数据时调用 */
- (void)noDataShowImage:(NSString *)imageName tipsArray:(NSArray *)tipsArray buttonTitleArray:(NSArray *)titleArray;

/** 有数据时调用 */
- (void)hidenoDataView;

/** 数据为空显示的按钮操作 */
@property (nonatomic, copy) void(^buttonClickBlock)(NSString *title);

@end
