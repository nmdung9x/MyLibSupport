//
//  UILabel+Utils.m
//  Sapo Partner
//
//  Created by DungNM-PC on 28/09/2020.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

- (CGFloat) getTextWidth;
{
    return [self.text sizeWithAttributes:@{ NSFontAttributeName : self.font }].width;
}

- (void) calcTextHeight;
{
    [self calcTextHeight:self.width];
}

- (void) calcTextHeight:(CGFloat)maxWidth;
{
    self.numberOfLines = 0;
    CGRect bounds = [self.text boundingRectWithSize:(CGSize){maxWidth, DBL_MAX }
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: self.font}
                                              context:nil];
    self.height = bounds.size.height;
}

- (NSInteger) countLine;
{
    CGFloat height = [self.text sizeWithAttributes:@{ NSFontAttributeName : self.font }].height;
    CGRect bounds = [self.text boundingRectWithSize:(CGSize){self.width, DBL_MAX }
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.font}
                                            context:nil];
    
    return (int) (bounds.size.height/height);
}

- (void) style0:(NSRange)range color:(UIColor *)color font:(UIFont *)font;
{
    NSMutableAttributedString *attContent = self.attributedText ? [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText] : [[NSMutableAttributedString alloc] initWithString:self.text];
    @try {
        NSDictionary *dictText = @{
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color //UITextAttributeTextColor
        };
        
        [attContent setAttributes:dictText range:range];
        self.attributedText = attContent;
    } @catch (NSException *exception) {
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
}

- (void) style:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
{
    NSMutableAttributedString *attContent = self.attributedText ? [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText] : [[NSMutableAttributedString alloc] initWithString:self.text];
    @try {
        NSDictionary *dictText = @{
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color //UITextAttributeTextColor
        };
        
        if ([self.text rangeOfString:text].location != NSNotFound && text.length > 0) {
            [attContent setAttributes:dictText range:[self.text rangeOfString:text]];
        }
        self.attributedText = attContent;
    } @catch (NSException *exception) {
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
}

@end
