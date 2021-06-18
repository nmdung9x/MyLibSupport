//
//  NSDate+Utils.m
//  XoSo24h
//
//  Created by Dao Quoc Khanh on 9/8/16.
//  Copyright © 2016 Dao Quoc Khanh. All rights reserved.
//

#import "NSDate+Utils.h"

static NSString * const RFC3339_full_date_Format = @"yyyy'-'MM'-'dd";
static NSString * const RFC3339_date_time_Format_Z = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
static NSString * const RFC3339_date_time_Format_Z_ms = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'";
static NSString * const RFC3339_full_date_Format_Offset = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssxxx";
static NSString * const RFC3339_full_date_Format_Offset_ms = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'Sxxx";


@implementation NSDate (Utils)

+ (NSDateFormatter *)dateFormatterUTC_en_US {
    NSDateFormatter * dF = [[NSDateFormatter alloc] init];
    [dF setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dF setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return dF;
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter * dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:format];
    [dF setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString * ret = [dF stringFromDate:self];
    if (ret == nil) ret = @"";
    return ret;
}

- (NSString *)stringWithFormatBD:(NSString *)format {
    NSDateFormatter * dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:format];
    [dF setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString * ret = [dF stringFromDate:self];
    if (ret == nil) ret = @"";
    return ret;
}

- (NSString *)stringDateSwagger20 {
    NSDateFormatter * dF = [[self class] dateFormatterUTC_en_US];
    [dF setDateFormat:RFC3339_full_date_Format];
    NSString * ret = [dF stringFromDate:self];
    return ret;
}

- (NSString *)stringDateTimeSwagger20 {
    NSDateFormatter * dF = [[self class] dateFormatterUTC_en_US];
    [dF setDateFormat:RFC3339_date_time_Format_Z];
    NSString * ret = [dF stringFromDate:self];
    return ret;
}

- (NSInteger) getDayOfWeek;
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en"]];
    NSString *temp = [dateFormatter stringFromDate:self];
    
    if ([temp isEqualToString:@"Monday"]) {
        return 2;
    } else if ([temp isEqualToString:@"Tuesday"]) {
        return 3;
    } else if ([temp isEqualToString:@"Wednesday"]) {
        return 4;
    } else if ([temp isEqualToString:@"Thursday"]) {
        return 5;
    } else if ([temp isEqualToString:@"Friday"]) {
        return 6;
    } else if ([temp isEqualToString:@"Saturday"]) {
        return 7;
    } else if ([temp isEqualToString:@"Sunday"]) {
        return 8;
    }
    return 0;
}

- (NSString *) getDayOfWeekVN;
{
    NSInteger dayOfWeek = [self getDayOfWeek];
    switch (dayOfWeek) {
        case 2:
            return @"Thứ hai";
            break;
            
        case 3:
            return @"Thứ Ba";
            break;
            
        case 4:
            return @"Thứ Tư";
            break;
            
        case 5:
            return @"Thứ Năm";
            break;
            
        case 6:
            return @"Thứ Sáu";
            break;
            
        case 7:
            return @"Thứ Bảy";
            break;
            
        case 8:
            return @"Chủ Nhật";
            break;
            
        default:
            break;
    }
    
    return @"";
}

+ (instancetype)dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter * dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:format];
    return [dF dateFromString:string];
}

+ (instancetype)dateWithStringDateSwagger20:(NSString *)string {
    NSDateFormatter * dF = [[self class] dateFormatterUTC_en_US];
    [dF setDateFormat:RFC3339_full_date_Format];
    NSDate *ret = [dF dateFromString:string];
    return ret;
}

+ (instancetype)dateWithStringDateTimeSwagger20:(NSString *)string {
    NSDateFormatter * dF = [[self class] dateFormatterUTC_en_US];
    NSDate *ret = nil;
    
    if (ret == nil) {
        [dF setDateFormat:RFC3339_full_date_Format_Offset_ms];
        ret = [dF dateFromString:string];
    }
    if (ret == nil) {
        [dF setDateFormat:RFC3339_full_date_Format_Offset];
        ret = [dF dateFromString:string];
    }
    if (ret == nil) {
        [dF setDateFormat:RFC3339_date_time_Format_Z_ms];
        ret = [dF dateFromString:string];
    }
    if (ret == nil) {
        [dF setDateFormat:RFC3339_date_time_Format_Z];
        ret = [dF dateFromString:string];
    }
    return ret;
}

+ (NSString *)stringForTimeInterval:(NSTimeInterval)ti {
    NSCalendar *currentCalendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [currentCalendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:ti] options:0];
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
    return [formatter stringFromDateComponents:components];
}

+ (NSString *)shortStandaloneWeekdaySymbolForWeekDay:(NSUInteger)weekday {
    NSDateFormatter * dF = [[NSDateFormatter alloc] init];
    NSArray *symbols = [dF shortStandaloneWeekdaySymbols];
    if (1 <= weekday && weekday <= [symbols count]) {
        return [symbols objectAtIndex:(weekday - 1)];
    }
    else {
        return nil;
    }
}

@end


@implementation NSCalendar (Utils)

- (NSDate *)correctDateFromComponents:(NSDateComponents *)comps {
    return [[self dateFromComponents:comps] dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];;
}

@end

