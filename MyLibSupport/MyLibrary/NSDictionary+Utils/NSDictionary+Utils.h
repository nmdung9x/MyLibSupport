//
//  NSDictionary+Utils.h
//  DMS
//
//  Created by NMD9x on 5/1/19.
//  Copyright © 2019 NMD9x. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Utils)

- (BOOL) isNull:(NSString *) key;
- (NSDictionary *) getDictionaryForKey:(NSString *) key;
- (NSString *) getStringForKey:(NSString *) key;
- (NSArray *) getArrayForKey:(NSString *) key;
- (NSString *) string;
- (NSString *) convertToString;
- (NSString *) convertToJSON;
- (NSMutableDictionary *) convertToNSMutableDic;
+ (NSDictionary *) convertFromNSMutableDic:(NSMutableDictionary *) mDic;

@end

NS_ASSUME_NONNULL_END
