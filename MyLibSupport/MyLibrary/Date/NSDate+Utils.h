//
//  NSDate+Utils.h
//  XoSo24h
//
//  Created by Dao Quoc Khanh on 9/8/16.
//  Copyright © 2016 Dao Quoc Khanh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+DateTools.h"

@interface NSDate (Utils)

- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithFormatBD:(NSString *)format;
- (NSString *)stringDateSwagger20;
- (NSString *)stringDateTimeSwagger20;
- (NSInteger) getDayOfWeek;
- (NSString *) getDayOfWeekVN;
+ (instancetype)dateWithString:(NSString *)string format:(NSString *)format;
+ (instancetype)dateWithStringDateSwagger20:(NSString *)string;
+ (instancetype)dateWithStringDateTimeSwagger20:(NSString *)string;
+ (NSString *)stringForTimeInterval:(NSTimeInterval)ti;
+ (NSString *)shortStandaloneWeekdaySymbolForWeekDay:(NSUInteger)weekday;

@end


@interface NSCalendar (Utils)

- (NSDate *)correctDateFromComponents:(NSDateComponents *)comps;

@end
