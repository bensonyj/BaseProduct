//
//  SQLManager.m
//  NetHospital
//
//  Created by yj on 16/4/12.
//  Copyright © 2016年 TCGroup. All rights reserved.
//

#import "SQLManager.h"
#import "FMDatabase.h"

@interface SQLManager ()

@property(nonatomic,copy) NSString *dbPath;

@end

static NSString * const tableCityAreaName = @"DBTable_CityArea";

@implementation SQLManager

+ (SQLManager *)shareManager
{
    static SQLManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SQLManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
//    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = [paths objectAtIndex:0];
//    self.dbPath = [documentPath stringByAppendingPathComponent:@"cityArea.db"];
//    
//    success = [fileManager fileExistsAtPath:self.dbPath];
//    
//    if (!success) {
//        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cityArea.db"];
//        success = [fileManager copyItemAtPath:defaultDBPath toPath:self.dbPath error:&error];
//        if (!success) {
//            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//        }
//    }
//    
//    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
//    if([db open])
//    {
//        [db close];
//    }
    
    self.dbPath = [[NSBundle mainBundle] pathForResource:@"cityArea.db" ofType:nil];

    return self;
}

#pragma mark - 城市地区

- (NSArray *)provinces
{
    NSMutableArray *provinces = nil;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        provinces = [[NSMutableArray alloc] init];
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where parent_code ='1' ORDER BY code ASC",tableCityAreaName];

        FMResultSet *queryResults = [db executeQuery:sql];
        while ([queryResults next]) {
            AreaInfo *areaModel = [[AreaInfo alloc] init];
            areaModel.name = [queryResults stringForColumn:@"name"] ;
            areaModel.parent_code = [queryResults intForColumn:@"parent_code"];
            areaModel.code = [queryResults intForColumn:@"code"];
            [provinces addObject:areaModel];
        }
        [db close];
    }
    return provinces;
}

- (NSArray *)citiesWithProvince:(NSInteger)provinceCode
{
    NSMutableArray *cities = nil;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        cities = [[NSMutableArray alloc] init];
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where parent_code like %ld ORDER BY code ASC",tableCityAreaName,(long)provinceCode];

        FMResultSet *queryResults = [db executeQuery:sql];
        while ([queryResults next]) {
            AreaInfo *city = [AreaInfo mj_objectWithKeyValues:[queryResults resultDictionary]];
            [cities addObject:city];
        }
        [db close];
    }
    return cities;
}

- (AreaInfo *)getCityCode:(NSString *)cityName
{
    AreaInfo *city = nil;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from '%@' where name = '%@'",tableCityAreaName,cityName];
        FMResultSet *queryResults = [db executeQuery:sql];
        while ([queryResults next]) {
            city = [AreaInfo mj_objectWithKeyValues:[queryResults resultDictionary]];
        }
        [db close];
    }
    return city;
}

- (NSString *)getProvince:(NSString *)provinceCode {
    NSString *province = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from '%@' where code = '%@'",tableCityAreaName,provinceCode];
        FMResultSet *queryResults = [db executeQuery:sql];
        while ([queryResults next]) {
            province = [AreaInfo mj_objectWithKeyValues:[queryResults resultDictionary]].name;
        }
        
        [db close];
    }
    return province;

}

- (NSString *)getCityName:(NSString *)cityCode {
    NSString *city = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from '%@' where code = '%@'",tableCityAreaName,cityCode];
        FMResultSet *queryResults = [db executeQuery:sql];
        while ([queryResults next]) {
            city = [AreaInfo mj_objectWithKeyValues:[queryResults resultDictionary]].name;
        }
        
        [db close];
    }
    return city;

}



@end
