//
//  UIView+Utils.m
//  DMS
//
//  Created by NMD9x on 4/18/19.
//  Copyright © 2019 NMD9x. All rights reserved.
//

#import "UIView+Utils.h"
#import <objc/runtime.h>
#import "CommonUtils.h"
#import "NSArray+Utils.h"
#import "UILabel+Utils.h"
#import "UIColor+Hex.h"
#import "UIImageView+Utils.h"

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;

@implementation UIView (Utils)


- (CGFloat)left {
    return self.frame.origin.x;
}



- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}



- (CGFloat)top {
    return self.frame.origin.y;
}



- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}



- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}



- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}



- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}



- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}



- (CGFloat)centerX {
    return self.center.x;
}



- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}



- (CGFloat)centerY {
    return self.center.y;
}



- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}



- (CGFloat)width {
    return self.frame.size.width;
}



- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}



- (CGFloat)height {
    return self.frame.size.height;
}



- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



- (CGFloat)screenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}



- (CGFloat)screenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}



- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}



- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}



- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}



- (CGPoint)origin {
    return self.frame.origin;
}



- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}



- (CGSize)size {
    return self.frame.size;
}



- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}



- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.height : self.width;
}



- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.width : self.height;
}



- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}



- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}


- (void)setTapActionWithBlock:(void (^)(void))block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

- (void)setLongPressActionWithBlock:(void (^)(void))block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
    
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

- (CGFloat) calcViewPosition:(CGFloat)padding;
{
    CGFloat offset = 0;
    
    for (UIView *v in [self subviews]) {
        if (!v.hidden) {
            offset += padding;
            v.top = offset;
            offset += v.height;
        }
    }
    self.height = offset + padding;
    return offset;
}

- (CGFloat) calcViewPosition;
{
    return [self calcViewPosition:0];
}

- (CGFloat) calcViewPosition2:(CGFloat)padding;
{
    CGFloat offset = 0;
    for (UIView *v in [self subviews]) {
        if (!v.hidden && v.tag >= 0) {
            offset += padding;
            v.top = offset;
            offset += v.height;
        }
    }
    
    self.height = offset + padding;
    return offset;
}

- (CGFloat) calcViewPosition2;
{
    return [self calcViewPosition2:0];
}

- (void) setCenterViews:(CGFloat)padding view1:(UIView *)view1 view2:(UIView *)view2;
{
    view2.top = view1.bottom + padding;
    CGFloat subView_h = view2.top + view2.height - view1.top;
    view1.top = self.height/2 - subView_h/2;
    view2.top = view1.bottom + padding;
}

- (void) removeAllView;
{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
}

- (void) removeAllView2;
{
    for (UIView *v in [self subviews]) {
        if (v.tag) continue;
        [v removeFromSuperview];
    }
}

- (CGRect) getFrameButtonForView:(CGFloat)margin;
{
    return CGRectMake(self.left - margin, self.top - margin, self.width + margin*2, self.height + margin*2);
}

- (void) checkScrollView:(UIScrollView *)viewScroll viewForcus:(UIView *)viewForcus keyboardHeight:(CGFloat)keyboardHeight;
{
    BOOL newWay = YES;
    if (newWay) {
        CGFloat statusbar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat view_height = self.height - keyboardHeight;
        CGFloat pos_scroll = viewForcus.bottom - view_height + statusbar_height;
        if (pos_scroll > 0) {
            [CommonUtils delay:200 block:^{
                [viewScroll setContentOffset:CGPointMake(0, pos_scroll) animated:YES];
            }];
        }
        return;
    }
    CGFloat statusbar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat view_height = self.height - keyboardHeight - statusbar_height;
    if (viewForcus) {
        CGFloat pos_view = viewForcus.bottom;
        CGFloat pos_scroll = pos_view - view_height;
        CGFloat height_tmp = viewScroll.height - keyboardHeight;
        
        if (pos_view > height_tmp) {
            [CommonUtils delay:300 block:^{
                [viewScroll setContentOffset:CGPointMake(0, pos_scroll) animated:YES];
            }];
        }
    }
}

- (CGFloat) getBottomOfBottomView;
{
    NSUInteger count = [self subviews].count;
    if (count > 0) {
        UIView *v = [[self subviews] safeObjectAtIndex:count - 1];
        return v ? v.bottom : 0;
    }
    return 0;
}

- (UIView *) addSubView:(UIView *) view;
{
    [self addSubview:view];
    return view;
}

- (UIView *) addCircleView:(CGRect)frame bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
{
    UIView *viewCircle = [[UIView alloc] initWithFrame:frame];
    viewCircle.backgroundColor = bgColor;
    viewCircle.clipsToBounds = YES;
    viewCircle.layer.cornerRadius = viewCircle.height/2;
    viewCircle.layer.borderWidth = borderWidth;
    viewCircle.layer.borderColor = borderColor.CGColor;
    
    [self addSubview:viewCircle];
    return viewCircle;
}

- (CustomView *) addCustomView:(CGRect) frame bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
{
    CustomView *view = [[CustomView alloc] initWithFrame:frame];
    if (bgColor) view.backgroundColor = bgColor;
    
    if (cornerRadius > 0 || borderWidth > 0) {
        view.clipsToBounds = YES;
        if (cornerRadius > 0) view.layer.cornerRadius = cornerRadius;
        if (borderWidth > 0) view.layer.borderWidth = borderWidth;
        if (borderColor) view.layer.borderColor = borderColor.CGColor;
    }
    [self addSubview:view];
    return view;
}

- (CustomButton *) addCustomButton:(CGRect) frame buttonTitle:(NSString *)title bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor targetView:(id)target action:(SEL)action;
{
    CustomButton *viewBtn = [[CustomButton alloc] initWithFrame:frame];
    if (viewBtn) [viewBtn setTitle:title forState:UIControlStateNormal];
    if (bgColor) viewBtn.backgroundColor = bgColor;
    
    if (cornerRadius > 0 || borderWidth > 0) {
        viewBtn.clipsToBounds = YES;
        if (cornerRadius > 0) viewBtn.layer.cornerRadius = cornerRadius;
        if (borderWidth > 0) viewBtn.layer.borderWidth = borderWidth;
        if (borderColor) viewBtn.layer.borderColor = borderColor.CGColor;
    }
    
    [self addSubview:viewBtn];
    if (target && action) {
        [viewBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return viewBtn;
}

- (CustomButton *) addCustomButtonForView:(UIView *) view targetView:(id)target action:(SEL)action;
{
    return [self addCustomButton:[view getFrameButtonForView:10] buttonTitle:@"" bgColor:[UIColor clearColor] cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor] targetView:target action:action];
}

- (CustomButton *) addCustomButtonForView:(UIView *) view margin:(CGFloat)margin targetView:(id)target action:(SEL)action;
{
    return [self addCustomButton:[view getFrameButtonForView:margin] buttonTitle:@"" bgColor:[UIColor clearColor] cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor] targetView:target action:action];
}

- (UIScrollView *) addScrollView:(CGRect) frame;
{
    UIScrollView *viewScroll = [[UIScrollView alloc] initWithFrame:frame];
    viewScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:viewScroll];
    [viewScroll setContentSize:CGSizeMake(viewScroll.frame.size.width, viewScroll.frame.size.height)];
    return viewScroll;
}

- (UIImageView *) addImageView:(CGRect) frame image:(UIImage *)image;
{
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:frame];
    if (image) viewImage.image = image;
    [self addSubview:viewImage];
    
    if (image && viewImage.width == 0) viewImage.width = [viewImage calcWidth];
    if (image && viewImage.height == 0) viewImage.height = [viewImage calcHeight];
    return viewImage;
}

- (UIImageView *) addImageView:(UIImage *)image paddingTop:(CGFloat)top paddingLR:(CGFloat)padding;
{
    return [self addImageView:CGRectMake(padding, [self getBottomOfBottomView] + top, self.width - (2*padding), 0) image:image];
}

- (UIImageView *) addImageView:(UIImage *)image paddingLR:(CGFloat)padding;
{
    return [self addImageView:image paddingTop:0 paddingLR:padding];
}

- (UILabel *) addLabelView:(CGRect) frame textLabel:(NSString *)text fontLabel:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor textAlignment:(NSTextAlignment) textAlignment numberOfLines:(NSInteger)numberOfLines sizeToFit:(BOOL)sizeToFit;
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text ? text : @"";
    label.textAlignment = textAlignment ? textAlignment : NSTextAlignmentLeft;
    if (font) label.font = font;
    if (textColor) label.textColor = textColor;
    if (bgColor) label.backgroundColor = bgColor;
    [self addSubview:label];
    
    label.numberOfLines = sizeToFit ? 0 : numberOfLines;
    
    if (sizeToFit) {
        [label calcTextHeight:frame.size.width];
    }
    
    return label;
}

- (UILabel *) addLabelView:(CGRect) frame textLabel:(NSString *)text fontLabel:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor textAlignment:(NSTextAlignment) textAlignment numberOfLines:(NSInteger)numberOfLines;
{
    return [self addLabelView:frame textLabel:text fontLabel:font textColor:textColor bgColor:bgColor textAlignment:textAlignment numberOfLines:numberOfLines sizeToFit:YES];
}

- (UILabel *) addLabelView:(NSString *)text fontLabel:(UIFont *)font paddingTop:(CGFloat)top paddingLR:(CGFloat)padding;
{
    return [self addLabelView:CGRectMake(padding, [self getBottomOfBottomView] + top, self.width - (2*padding), 0) textLabel:text fontLabel:font textColor:[UIColor colorWithHex:0x343741] bgColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numberOfLines:0];
}

- (void) animationScale:(void (^)(void))completeBlock;
{
    [self animationScale:0.95 completion:completeBlock];
}

- (void) animationScale:(CGFloat)scale completion:(void (^)(void))completeBlock;
{
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1, 1);
        completeBlock();
    }];
}
@end
