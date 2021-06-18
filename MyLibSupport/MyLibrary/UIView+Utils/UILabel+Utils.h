//
//  UILabel+Utils.h
//  Sapo Partner
//
//  Created by DungNM-PC on 28/09/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Utils)

- (CGFloat) getTextWidth;
- (void) calcTextHeight;
- (void) calcTextHeight:(CGFloat)maxWidth;
- (NSInteger) countLine;
- (void) style0:(NSRange)range color:(UIColor *)color font:(UIFont *)font;
- (void) style:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
