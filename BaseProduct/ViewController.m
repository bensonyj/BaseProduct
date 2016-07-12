//
//  ViewController.m
//  BaseProduct
//
//  Created by yj on 16/1/18.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//测试样式

#pragma mark - 有上拉加载和下拉刷新
//[self configureRefreshHeader:self.tableView];
//
//[self beginDataRefresh];

//- (void)refreshData
//{
//    [super refreshData];
//    
//    @weakify(self);
//    [[AFNetWorkUtils racPOSTWthURL:cpsHomeUrl params:@{@"page_no":@(self.startPage),@"page_size":@(self.perPageCount),@"type_id":@(self.matchTypeInfo.type_id)}] subscribeNext:^(NSDictionary *bodyDict) {
//        @strongify(self);
//        if (self.refreshStatus != refreshType_PullUp) {
//            //清空数据
//            [self.dataList removeAllObjects];
//        }
//        [self endDataRefresh];
//        
//        NSMutableArray *list = [NSMutableArray arrayWithArray:[CompetitionInfo mj_objectArrayWithKeyValuesArray:bodyDict[@"cp_list"]]];
//        //去重
//        NSArray *distnctArray = [self noDuplicateListWithadditionList:list];
//        [self.dataList addObjectsFromArray:distnctArray];
//        
//        if ([self.dataList count] == 0) {
//            [self noDataShowImage:@"no_data" tipsArray:nil buttonTitleArray:nil];
//        }
//        [self.tableView reloadData];
//    } error:^(NSError *error) {
//        [self endDataRefresh];
//        //错误
//        if ([self.dataList count] == 0) {
//            //列表无数据
//            if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
//                //无网络则显示notview提示
//                [self showNotNetView];
//                @weakify(self);
//                self.buttonClick = ^(NSString *title) {
//                    @strongify(self);
//                    if ([title isEqualToString:@"重新加载"]) {
//                        [self beginDataRefresh];
//                    }
//                };
//            }else{
//                //其他错误则显示空view提示
//                [self noDataShowImage:@"no_data" tipsArray:nil buttonTitleArray:nil];
//            }
//        }
//        
//        [AFNetWorkUtils show:[error.userInfo objectForKey:@"customErrorInfoKey"] view:self.view];
//    }];
//}

#pragma mark - 无下拉刷新，有上拉加载
//[self configureRefreshFooter:self.tableView];
//[self showDataLoadingView];
//[self refreshData];
//- (void)refreshData
//{
//    [super refreshData];
//    
//    @weakify(self);
//    [[AFNetWorkUtils racPOSTWthURL:cpsExpertUrl params:@{@"expert_id":@(self.expertInfo.user_id),@"page_no":@(self.startPage),@"page_size":@(self.perPageCount)}] subscribeNext:^(NSDictionary *bodyDict) {
//        @strongify(self);
//        
//        [self dismissDataLoadingView];
//        [self endDataRefresh];
//        
//        NSMutableArray *list = [NSMutableArray arrayWithArray:[CompetitionInfo mj_objectArrayWithKeyValuesArray:bodyDict[@"cp_list"]]];
//        //去重
//        NSArray *distnctArray = [self noDuplicateListWithadditionList:list];
//        [self.dataList addObjectsFromArray:distnctArray];
//        
//        [self.tableView reloadData];
//        if ([self.dataList count] == 0) {
//            [self noDataShowImage:@"no_data" tipsArray:nil buttonTitleArray:nil];
//        }
//    } error:^(NSError *error) {
//        [self endDataRefresh];
//        [self dismissDataLoadingView];
//        //错误
//        if ([self.dataList count] == 0) {
//        //列表无数据
//        if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
//            //无网络则显示notview提示
//            [self showNotNetView];
//            @weakify(self);
//            self.buttonClick = ^(NSString *title) {
//                @strongify(self);
//                if ([title isEqualToString:@"重新加载"]) {
//                    [self beginDataRefresh];
//                }
//            };
//        }else{
//            //其他错误则显示空view提示
//            [self noDataShowImage:@"no_data" tipsArray:nil buttonTitleArray:nil];
//        }
//        [AFNetWorkUtils show:[error.userInfo objectForKey:@"customErrorInfoKey"] view:self.view];
//    }];
//}

#pragma mark - 事件点击
//[self showHUD:@"正在加载..."];
//@weakify(self);
//[[AFNetWorkUtils racPOSTWthURL:expertFollowUrl params:@{@"expert_id":@(_competitionInfo.add_user_id),@"follow_type":button.selected ? @(2):@(1)}] subscribeNext:^(id x) {
//    [self hideHUD];
//    
//    @strongify(self);
//    self.competitionInfo.is_followed = !_competitionInfo.is_followed;
//    if (self.isfollowBlock) {
//        self.isfollowBlock(button.selected);
//    }
//} error:^(NSError *error) {
//    [self hideHUD];
//    
//    [AFNetWorkUtils show:[error.userInfo objectForKey:@"customErrorInfoKey"] view:self.view];
//}];


@end
