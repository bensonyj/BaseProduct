//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

//#import "Bee_Precompile.h"

#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

#pragma mark -

@interface NSDate(BeeExtension)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;
@property (nonatomic, readonly) NSInteger	weekdayOrdinal;         //这个月的第几周
@property (nonatomic, readonly) NSInteger   age;


/** 当前时间 */
+ (NSDate *)now;
/** 获得时间戳 long类型*/
+ (long long)timeStamp;
/** 获得时间戳 string类型 */
+ (NSString *)timeStampString;

/** 一天的开始时间 */
- (NSDate *)beginOfDay;
/** 一天的结束时间 */
- (NSDate *)endOfDay;

#pragma mark - 时间转换

/** 获得NSDate类型，传入需转换的时间字符串和转换类型 */
+ (NSDate *)dateWithString:(NSString *)string DateFormat:(NSString *)format;
/** 获得NSDate类型 string must follow the format: yyyy-MM-dd HH:mm:ss*/
+ (NSDate *)dateWithString:(NSString *)string;
/** 获得NSDate（YYYY-MM-DD）类型 string must follow the format: yyyy-MM-dd HH:mm:ss*/
+ (NSDate *)dateWithYYYYMMDDString:(NSString *)string;
/** 获得string类型，传入参数为要获得的类型 */
- (NSString *)stringWithDateFormat:(NSString *)format;

#pragma mark - 时间计算与比较

/** 判断时间距离现在差多久，以刚刚、几分钟前表示 */
- (NSString *)timeAgo;
/** 判断日期是今天，昨天还是明天 */
- (NSString *)compareDate:(NSDate *)date;

/** 获取月份的天数 */
- (NSInteger)numberOfDaysInMonth;

/** 日期相隔多少天 */
- (NSInteger)daysSinceDate:(NSDate *)anotherDate;

/** 判断是否闰年 */
- (BOOL)isLeapYear;

/** 是否是同一天 */
- (BOOL)isSameDay:(NSDate *)anotherDate;

/** 是否是今天 */
- (BOOL)isToday;

/** 距离现在几年后，传入年数 */
+ (NSDate *) dateWithYearsFromNow:(NSInteger) years;
/** 距离现在几天后，传入天数 */
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
/** 距离现在几天前，传入天数 */
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
/** 距离现在几小时后，传入小时数 */
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
/** 距离现在几小时前，传入小时数 */
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
/** 距离现在几分钟后，传入分钟数 */
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
/** 距离现在几分钟前，传入分钟数 */
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

@end
