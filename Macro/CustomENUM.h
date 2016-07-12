//
//  CustomENUM.h
//  BaseProduct
//
//  Created by yj on 16/1/20.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#ifndef CustomENUM_h
#define CustomENUM_h

/** 刷新状态 */
typedef NS_ENUM(NSUInteger,RefreshType) {
    refreshType_Normal,
    refreshType_PullUp,     ///< 下拉刷新
    refreshType_PullDown    ///< 上拉加载
};

/** 网络提示框的出现时机，若干秒后网络数据还未返回则出现提示框 */
typedef NS_ENUM(NSUInteger, NetworkRequestGraceTimeType){
    NetworkRequestGraceTimeTypeNormal,  // 0.5s
    NetworkRequestGraceTimeTypeLong,    // 1s
    NetworkRequestGraceTimeTypeShort,   // 0.1s
    NetworkRequestGraceTimeTypeAlways   // 总是有提示框
};

#endif /* CustomENUM_h */
