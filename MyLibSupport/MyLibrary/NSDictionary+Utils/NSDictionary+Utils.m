//
//  NSDictionary+Utils.m
//  DMS
//
//  Created by NMD9x on 5/1/19.
//  Copyright © 2019 NMD9x. All rights reserved.
//

#import "NSDictionary+Utils.h"
#import "NSString+Utils.h"
#import "LogUtils.h"

@implementation NSDictionary (Utils)

- (BOOL) isNull:(NSString *) key;
{
    if (self == nil) return YES;
    if ([key isEmpty]) return YES;
    if ([self objectForKey:key] == nil) return YES;
    return NO;
}

- (NSDictionary *) getDictionaryForKey:(NSString *) key;
{
    if ([self isNull:key]) return nil;
    @try {
        NSString *result = @"";
        if ([self objectForKey:key] != nil) {
            result = [NSString stringWithFormat:@"%@", [self objectForKey:key]];
        }
        if (result == nil) {
            return nil;
        }
        if (result.length == 0) {
            return nil;
        }
        if ([result isEqualToString:@"<null>"]) {
            return nil;
        }
        if ([result isEqualToString:@"(null)"]) {
            return nil;
        }
    } @catch (NSException *exception) {}
    @try {
        if ([self objectForKey:key] != [NSNull null]) {
            return [self objectForKey:key];
        }
    } @catch (NSException *exception) {
        return nil;
    }
}

- (NSString *) getStringForKey:(NSString *) key;
{
    if ([self isNull:key]) return @"";
    NSString *result = @"";
    @try {
        if ([self objectForKey:key] != [NSNull null]) {
            result = [NSString stringWithFormat:@"%@", [self objectForKey:key]];
        }
    } @catch (NSException *exception) {
        result = @"";
    }
    if (result == nil) {
        result = @"";
    }
    if ([result isEqualToString:@"<null>"]) {
        result = @"";
    }
    if ([result isEqualToString:@"(null)"]) {
        result = @"";
    }
    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSArray *) getArrayForKey:(NSString *) key;
{
    if ([self isNull:key]) {
        return [NSArray new];
    }
    @try {
        id result = [self objectForKey:key];
        if (result == nil) {
            return [NSArray new];
        }
        if ([result isKindOfClass:[NSArray class]]) {
            return [self objectForKey:key];
        } else if ([result isKindOfClass:[NSMutableArray class]]) {
            return [NSArray arrayWithArray:[self objectForKey:key]];
        } else {
            return [NSArray new];
        }
    } @catch (NSException *exception) {
        return [NSArray new];
    }
    
    return [NSArray new];;
}

- (NSString *) string;
{
    if (self == nil) return @"";
    NSString *results = @"{";
    NSArray *keys = [self allKeys];
    
    if (keys.count > 0) {
        BOOL comma = NO;
        for (NSString *key in keys) {
            if (comma) {
                results = [results appendingString:@","];
            } else comma = YES;
            
            results = [results appendingString:@"\""];
            results = [results appendingString:key];
            results = [results appendingString:@"\""];
            results = [results appendingString:@":"];
            
            id tmp = [self objectForKey:key];
            if ([tmp isKindOfClass:[NSDictionary class]]) {
                results = [results appendingString:[(NSDictionary *) tmp string]];
            } else if ([tmp isKindOfClass:[NSArray class]]) {
                NSArray *arrTmp = (NSArray *)tmp;
                results = [results appendingString:@"["];
                BOOL comma2 = NO;
                for (NSDictionary *dicItem in arrTmp) {
                    if (comma2) {
                        results = [results appendingString:@","];
                    } else comma2 = YES;
                    
                    results = [results appendingString:[dicItem string]];
                }
                results = [results appendingString:@"]"];
            } else {
                results = [results appendingString:@"\""];
                results = [results appendingString:[self getStringForKey:key]];
                results = [results appendingString:@"\""];
            }
        }
    }
    
    return [results appendingString:@"}"];
}

- (NSString *) convertToString;
{
    if (self == nil) return @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (error) return @"";
    if (!jsonData) {
        return @"";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ([jsonString isEmpty]) return @"";
        return jsonString;
    }
}

- (NSString *) convertToJSON;
{
    if (self == nil) return @"{}";
    NSError *error;
    NSData *jsonData = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                   options:(NSJSONWritingOptions) NSJSONWritingPrettyPrinted
                                                     error:&error];
    } @catch (NSException *exception) {
        DLog(@"%@", [exception description]);
    }
    
    if (error) return @"{}";
    if (!jsonData) {
        return @"{}";
    } else {
        @try {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } @catch (NSException *exception) {
            DLog(@"%@", [exception description]);
        }
        return @"{}";
    }
}


- (NSMutableDictionary *) convertToNSMutableDic;
{
    return [NSMutableDictionary dictionaryWithDictionary:self];
}

+ (NSDictionary *) convertFromNSMutableDic:(NSMutableDictionary *) mDic;
{
    return [[NSDictionary alloc] initWithDictionary:mDic];
}

@end
