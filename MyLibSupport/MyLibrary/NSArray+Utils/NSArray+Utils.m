//
//  UIImage+Color.m
//  Likeastore
//
//  Created by Dmitri Voronianski on 14.05.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (instancetype)arrayWithUniqueObjects
{
    NSMutableArray *uniqueObjects = [NSMutableArray new];
    for(id obj in self) {
        if([uniqueObjects containsObject:obj] == NO) {
            [uniqueObjects addObject:obj];
        }
    }
    return uniqueObjects;
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index >= self.count)
        return nil;
    return self[index];
}

- (NSMutableArray *) convertToNSMutableArray;
{
    return [NSMutableArray arrayWithArray:self];
}

- (NSString *) convertToString;
{
    NSError *error;
    NSData *jsonData = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                   options:nil
                                                     error:&error];
    } @catch (NSException *exception) {
        DLog(@"%@", [exception description]);
    }
    if (!error) {
        @try {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } @catch (NSException *exception) {
            DLog(@"%@", [exception description]);
        }
    }
    return @"";
}

- (NSString *) convertToJSON;
{
    if (self == nil) return @"[]";
    if (self.count > 0) {
        NSError *error;
        NSData *jsonData = nil;
        
        @try {
            jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) NSJSONWritingPrettyPrinted
                                                         error:&error];
        } @catch (NSException *exception) {
            DLog(@"%@", [exception description]);
        }
        if (error) {
            NSString *results = @"[";
            int i = 0;
            for (id tmp in self) {
                results = [results appendingString:@"\n"];
                if ([tmp isKindOfClass:[NSDictionary class]] || [tmp isKindOfClass:[NSMutableDictionary class]]) {
                    results = [results appendingString:[tmp convertToJSON]];
                } else results = [results appendingString:[tmp description]];
                if (i < self.count - 1) results = [results appendingString:@","];
                i++;
            }
            results = [results appendingString:@"\n]"];
            return results;
        } else {
            @try {
                return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } @catch (NSException *exception) {
                DLog(@"%@", [exception description]);
            }
        }
    }
    return @"[]";
}

+ (NSArray *) convertFromNSMutableArray:(NSMutableArray *)mArray;
{
    return [[NSArray alloc] initWithArray:mArray];
}

@end
