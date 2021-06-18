//
//  CommonUtils.h
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import <Foundation/Foundation.h>
#import "MZFormSheetPresentationViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_X MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) == 812.0)

NS_ASSUME_NONNULL_BEGIN

@interface CommonUtils : NSObject

+ (NSString *) getStoredValueForKey:(NSString *)key;
+ (void) setStoredValueForKey:(NSString *)key value:(id)value;
+ (void) setStoredValuesForKeys:(NSMutableDictionary *) data;

+ (void)delay:(NSInteger)miliSec block:(void (^)(void))completeBlock;
+ (void)delay:(NSInteger)miliSec tag:(NSString *)tag block:(void(^)(NSString *tag)) block;
+ (NSString *) checkDeviceModel;
+ (UIFont *) font:(CGFloat)fontSize;
+ (UIFont *) font:(NSString *) fontName fontSize:(CGFloat)fontSize;
+ (UIFont *) fontBold:(CGFloat)fontSize;
+ (UIFont *) fontItalic:(CGFloat)fontSize;
+ (UIToolbar *) addUIToolbarKeyboard:(id)target action:(SEL)action;
+ (MZFormSheetPresentationViewController *)showPopupFrom:(UIViewController*)fromViewController withContentViewController:(UIViewController*)contentViewController withSize:(CGSize)size;
+ (MZFormSheetPresentationViewController *)showBottomPopupFrom:(UIViewController*)fromViewController withContentViewController:(UIViewController*)contentViewController withSize:(CGSize)size;
+ (MZFormSheetPresentationViewController *)showPopupFromPosition:(UIViewController*)fromViewController withContentViewController:(UIViewController*)contentViewController withSize:(CGSize)size position:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
