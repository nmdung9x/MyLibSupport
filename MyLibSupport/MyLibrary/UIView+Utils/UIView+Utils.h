//
//  UIView+Utils.h
//  DMS
//
//  Created by NMD9x on 4/18/19.
//  Copyright © 2019 NMD9x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CustomView.h"
#import "CustomButton.h"

@interface UIView (Utils)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat screenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationHeight;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 Attaches the given block for a single tap action to the receiver.
 @param block The block to execute.
 */
- (void)setTapActionWithBlock:(void (^)(void))block;

/**
 Attaches the given block for a long press action to the receiver.
 @param block The block to execute.
 */
- (void)setLongPressActionWithBlock:(void (^)(void))block;

- (CGFloat) calcViewPosition;
- (CGFloat) calcViewPosition:(CGFloat)padding;
- (CGFloat) calcViewPosition2;
- (CGFloat) calcViewPosition2:(CGFloat)padding;

- (void) setCenterViews:(CGFloat)padding view1:(UIView *)view1 view2:(UIView *)view2;
- (void) removeAllView;
- (void) removeAllView2;
- (CGRect) getFrameButtonForView:(CGFloat)margin;

- (void) checkScrollView:(UIScrollView *)viewScroll viewForcus:(UIView *)viewForcus keyboardHeight:(CGFloat)keyboardHeight;

- (CGFloat) getBottomOfBottomView;
- (UIView *) addSubView:(UIView *) view;
- (UIView *) addCircleView:(CGRect)frame bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (CustomView *) addCustomView:(CGRect) frame bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
- (CustomButton *) addCustomButton:(CGRect) frame buttonTitle:(NSString *)title bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor targetView:(id)target action:(SEL)action;
- (CustomButton *) addCustomButtonForView:(UIView *) view targetView:(id)target action:(SEL)action;
- (CustomButton *) addCustomButtonForView:(UIView *) view margin:(CGFloat)margin targetView:(id)target action:(SEL)action;
- (UIScrollView *) addScrollView:(CGRect) frame;
- (UIImageView *) addImageView:(CGRect) frame image:(UIImage *)image;
- (UIImageView *) addImageView:(UIImage *)image paddingTop:(CGFloat)top paddingLR:(CGFloat)padding;
- (UIImageView *) addImageView:(UIImage *)image paddingLR:(CGFloat)padding;

- (UILabel *) addLabelView:(CGRect) frame textLabel:(NSString *)text fontLabel:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor textAlignment:(NSTextAlignment) textAlignment numberOfLines:(NSInteger)numberOfLines sizeToFit:(BOOL)sizeToFit;
- (UILabel *) addLabelView:(CGRect) frame textLabel:(NSString *)text fontLabel:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor textAlignment:(NSTextAlignment) textAlignment numberOfLines:(NSInteger)numberOfLines;
- (UILabel *) addLabelView:(NSString *)text fontLabel:(UIFont *)font paddingTop:(CGFloat)top paddingLR:(CGFloat)padding;
- (void) animationScale:(void (^)(void))completeBlock;
- (void) animationScale:(CGFloat)scale completion:(void (^)(void))completeBlock;
- (void) addShadowForView;
- (void) addShadowBottomForView;
@end
