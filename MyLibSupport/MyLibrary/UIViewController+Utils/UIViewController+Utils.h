//
//  UIViewController+Utils.h
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIViewController (Utils)

- (UIViewController *) topViewController;
- (UIViewController *) topViewController:(UIViewController *)rootViewController;
- (void) showDateTimePicker:(NSDate * _Nullable )defaultDate
                     minDate:(NSDate * _Nullable )minDate
                     maxDate:(NSDate * _Nullable )maxDate
              showTimePicker:(BOOL)showTimePicker
                       block:(void(^)(NSDate * _Nullable date, BOOL isClear)) block;

@end
