//
//  AppMacros.h
//  BaseProduct
//
//  Created by yj on 16/1/20.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#ifndef AppMacros_h
#define AppMacros_h

#define PUBLISH 1

#if (PUBLISH == 1)
//正式环境
//static NSString* const hostUrl = @"http://fs.51zcds.com:8087/app/";
#define kAPIURL @"http://tfs.51zcds.com:8086/app/"
#elif (PUBLISH == 2)
//调试环境
#define kAPIURL @"http://tfs.51zcds.com:8086/app/"

//static NSString* const hostUrl = @"http://tfs.51zcds.com:8086/app/";
#else
//测试环境
#define kAPIURL @"http://tfs.51zcds.com:8086/app/"

//static NSString* const hostUrl = @"http://tfs.51zcds.com:8086/app/";
#endif

#endif /* AppMacros_h */
