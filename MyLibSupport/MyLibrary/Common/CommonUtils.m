//
//  CommonUtils.m
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (void)delay:(NSInteger)miliSec block:(void (^)(void))completeBlock;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, miliSec * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        completeBlock();
    });
}

+ (void)delay:(NSInteger)miliSec tag:(NSString *)tag block:(void(^)(NSString *tag)) block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, miliSec * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        block(tag);
    });
}

@end
