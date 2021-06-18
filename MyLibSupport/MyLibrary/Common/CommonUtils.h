//
//  CommonUtils.h
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonUtils : NSObject

+ (void)delay:(NSInteger)miliSec block:(void (^)(void))completeBlock;
+ (void)delay:(NSInteger)miliSec tag:(NSString *)tag block:(void(^)(NSString *tag)) block

@end

NS_ASSUME_NONNULL_END
