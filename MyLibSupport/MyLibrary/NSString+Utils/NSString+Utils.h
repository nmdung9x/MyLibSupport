//
//  NSString+Utils.h
//  DMS
//
//  Created by NMD9x on 5/1/19.
//  Copyright © 2019 NMD9x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define isStrNil(...) __VA_ARGS__ ? : @""
#define formatStr(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utils)

- (BOOL) isEmpty;
- (BOOL) isContains:(NSString *)text;
- (BOOL) contains:(NSString *)text;
- (NSArray *) split:(NSString *) regex;
- (NSString *)trimWhiteSpace;
- (NSString *) replaceString:(NSString *)target withString:(NSString *)replacement;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (NSString *) parseFromFloat;
- (NSString *) appendingString:(NSString *)text;
- (NSDictionary *) convertToDictionary;
- (NSArray *) convertToArrayJson;
- (NSMutableDictionary *) parseQueryToDictionary;
- (NSString *) removeAccentsText;
- (NSString *) parseHTMLString;
- (UIColor*) colorWithHexString;
- (NSString *)indexOfString:(int)position;
- (NSDate *) convert:(NSString *) format;
- (NSDate *) convertUTC:(NSString *) format;
- (NSString *) encodingUTF8;
- (void) openWebsite;
- (UIImage *) decodeBase64ToImage;
- (NSMutableAttributedString *) stylingAttributedString:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
- (NSMutableAttributedString *) stylingAttributedString:(NSString *)text
                                                 color0:(UIColor *)color0
                                                  font0:(UIFont *)font0
                                                  color:(UIColor *)color
                                                   font:(UIFont *)font;

+ (BOOL)isNullOrEmpty:(NSString *)s;
+ (NSString *) join:(NSArray *) array regex:(NSString *) regex;
+ (NSString *) randomStringWithLength:(int) len;
+ (NSString *) randomStringWithLength:(NSString *)letters len:(int) len;

@end

NS_ASSUME_NONNULL_END
