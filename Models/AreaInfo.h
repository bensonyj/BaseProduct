//
//  AreaInfo.h
//  NetHospital
//
//  Created by yj on 16/4/12.
//  Copyright © 2016年 TCGroup. All rights reserved.
//

#import "BaseModel.h"

@interface AreaInfo : BaseModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger parent_code;

@end
