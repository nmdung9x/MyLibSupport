//
//  NSArray+Utils.h
//
//
//
//  Copyright (c) 2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

- (instancetype)arrayWithUniqueObjects;
- (id)safeObjectAtIndex:(NSInteger)index;
- (NSMutableArray *) convertToNSMutableArray;
- (NSString *) convertToString;
- (NSString *) convertToJSON;
+ (NSArray *) convertFromNSMutableArray:(NSMutableArray *)mArray;
@end
