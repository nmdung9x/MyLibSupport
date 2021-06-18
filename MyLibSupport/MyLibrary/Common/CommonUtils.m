//
//  CommonUtils.m
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import "CommonUtils.h"
#import "NSDictionary+Utils.h"
#import "PopupCustomViewController.h"

@implementation CommonUtils

+ (NSString *) getStoredValueForKey:(NSString *)key;
{
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (result == nil) return @"";
    return [NSString stringWithFormat:@"%@", result];
}

+ (void) setStoredValueForKey:(NSString *)key value:(id)value;
{
    if (key == nil) return;
    if (value == nil) return;
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setStoredValuesForKeys:(NSMutableDictionary *) data;
{
    if (data == nil) return;
    if (data.count == 0) return;
    NSArray *keys = [data allKeys];
    if (keys.count > 0) {
        for (NSString *key in keys) {
            [[NSUserDefaults standardUserDefaults] setObject:[data getStringForKey:key] forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

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

+ (NSString *) checkDeviceModel;
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        CGFloat height = [[UIScreen mainScreen] bounds].size.height;
        
        if (height >= 810) {
            return @"X"; //iPhone X
        } else {
            if (height >= 736) {
                return @"P"; //Plus: iPhone 6+/6S+/7+/8+
            } else {
                if (height >= 667) {
                    return @"N"; //Normal: iPhone 6/6S/7/8
                } else {
                    if (height >= 568) {
                        return @"M"; //Medium: iPhone 5/5S/5C
                    } else {
                        return @"S"; //Small: iPhone 4/4S
                    }
                }
            }
        }
        
    }
    return @"";
}

+ (UIFont *) fontBold:(CGFloat)fontSize;
{
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *) font:(CGFloat)fontSize;
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *) fontItalic:(CGFloat)fontSize;
{
    return [UIFont italicSystemFontOfSize:fontSize];
}

+ (UIFont *) font:(NSString *) fontName fontSize:(CGFloat)fontSize;
{
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIToolbar *) addUIToolbarKeyboard:(id)target action:(SEL)action;
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Xong"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:target
                                                                  action:action];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexBarButton, doneButton, nil]];
    //    tfView.inputAccessoryView = keyboardToolbar;
    return keyboardToolbar;
}

+ (MZFormSheetPresentationViewController *)showPopupFrom:(UIViewController*)fromViewController withContentViewController:(UIViewController*)contentViewController withSize:(CGSize)size;
{
    if ([contentViewController isKindOfClass:[PopupCustomViewController class]]) {
        PopupCustomViewController *popup = (PopupCustomViewController *) contentViewController;
        popup.widthV = size.width;
    }
    
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:contentViewController];
    formSheetController.presentationController.contentViewSize = size;
    formSheetController.presentationController.shouldShowInPosition = NO;
    formSheetController.presentationController.shouldCenterVertically = YES;
    formSheetController.presentationController.shouldCenterHorizontally = YES;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    //    formSheetController.disablesAutomaticKeyboardDismissal = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleFade;
    formSheetController.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTopInset;
    [fromViewController presentViewController:formSheetController animated:YES completion:nil];
    
    return formSheetController;
}


+ (MZFormSheetPresentationViewController *)showBottomPopupFrom:(UIViewController*)fromViewController withContentViewController:(UIViewController*)contentViewController withSize:(CGSize)size;
{
    if ([contentViewController isKindOfClass:[PopupCustomViewController class]]) {
        PopupCustomViewController *popup = (PopupCustomViewController *) contentViewController;
        popup.widthV = size.width;
    }
    
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:contentViewController];
    formSheetController.presentationController.contentViewSize = size;
    formSheetController.presentationController.shouldShowInPosition = NO;
    formSheetController.presentationController.shouldCenterHorizontally = YES;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.shouldShowInBottom = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
    formSheetController.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTopInset;
    [fromViewController presentViewController:formSheetController animated:YES completion:nil];
    
    return formSheetController;
}

+ (MZFormSheetPresentationViewController *)showPopupFromPosition:(UIViewController*)fromViewController withContentViewController:(UIViewController*)contentViewController withSize:(CGSize)size position:(CGPoint)position;
{
    if ([contentViewController isKindOfClass:[PopupCustomViewController class]]) {
        PopupCustomViewController *popup = (PopupCustomViewController *) contentViewController;
        popup.widthV = size.width;
    }
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:contentViewController];
    formSheetController.presentationController.contentViewSize = size;
    formSheetController.presentationController.contentViewPosition = position;
    formSheetController.presentationController.shouldShowInPosition = YES;
    formSheetController.presentationController.shouldShowInBottom = NO;
    formSheetController.presentationController.shouldCenterHorizontally = NO;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    //    formSheetController.disablesAutomaticKeyboardDismissal = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleFade;
    
    formSheetController.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTopInset;
    [fromViewController presentViewController:formSheetController animated:YES completion:nil];
    
    return formSheetController;
}


@end
