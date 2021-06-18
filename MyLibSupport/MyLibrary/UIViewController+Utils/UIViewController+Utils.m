//
//  UIViewController+Utils.m
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import "UIViewController+Utils.h"
#import "DateTimePickerView.h"
#import "PopupCustomViewController.h"
#import "CommonUtils.h"
#import "UIView+Utils.h"

@implementation UIViewController (Utils)

- (UIViewController *) topViewController;
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *) topViewController:(UIViewController *)rootViewController;
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self topViewController:rootViewController];
    }
    return rootViewController;
}

- (void) showDateTimePicker:(NSDate * _Nullable )defaultDate
                     minDate:(NSDate * _Nullable )minDate
                     maxDate:(NSDate * _Nullable )maxDate
              showTimePicker:(BOOL)showTimePicker
                       block:(void(^)(NSDate * _Nullable date, BOOL isClear)) block;
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width-4;
    DateTimePickerView *view = [[DateTimePickerView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    view.tag = 22869;
    
    view.minDate = minDate;
    view.maxDate = maxDate;
    view.defaultDate = defaultDate;
    view.showTimePicker = showTimePicker;
    
    view.btnLeftTitle = @"Xóa";
    
    [view initView];
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 10;
    
    PopupCustomViewController *popup = [[PopupCustomViewController alloc] init];
    popup.tagVC = view.tag;
    [CommonUtils showBottomPopupFrom:self withContentViewController:popup withSize:view.size];
    [popup setCustomView:view];
    
    [view completeSelectItem:^(NSDate * _Nullable date, BOOL isClear) {
        [popup closeView];
        block(date, isClear);
    }];
}

@end
