//
//  NSString+Utils.m
//  DMS
//
//  Created by NMD9x on 5/1/19.
//  Copyright © 2019 NMD9x. All rights reserved.
//

#import "NSString+Utils.h"
#import "UIColor+Hex.h"
#import "LogUtils.h"
#import "NSArray+Utils.h"

@implementation NSString (Utils)

- (BOOL) isEmpty;
{
    if (self) {
        if (self.length == 0) return YES;
        if ([self isEqualToString:@"(null)"]) return YES;
    } else return YES;
    return NO;
}

- (BOOL) isContains:(NSString *)text;
{
    return [self contains:text];
}


- (BOOL) contains:(NSString *)text;
{
    if ([self isEmpty]) return NO;
    if ([self isEqualToString:text]) return YES;
    NSRange range = [self rangeOfString:text];
    if (range.location == NSNotFound && range.length == NSNotFound) {
        return NO;
    } else {
        if (range.length == 0) {
            return NO;
        }
        return YES;
    }
}

- (NSArray *) split:(NSString *) regex;
{
    return [self componentsSeparatedByString:regex];
}

+ (NSString *) join:(NSArray *) array regex:(NSString *) regex;
{
    return [array componentsJoinedByString:regex];
}

+ (BOOL)isNullOrEmpty:(NSString *)s
{
    if(s == nil ||
       s.length == 0 ||
       [s isEqualToString:@""] ||
       [s isEqualToString:@"(null)"])
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)trimWhiteSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *) replaceString:(NSString *)target withString:(NSString *)replacement;
{
    if ([self contains:target]) {
        return [self stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    return self;
}

- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbers].location == NSNotFound);
}

- (BOOL)containsOnlyNumbersAndLetters;
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (NSString *) parseFromFloat;
{
    @try {
        float vFloat = [self floatValue];
        return [NSString stringWithFormat:@"%.0f", vFloat];
    } @catch (NSException *exception) {
    }
    if (self.length > 0) return self;
    return @"0";
}

- (NSString *) appendingString:(NSString *)text;
{
    return [self stringByAppendingString:text];
}

- (NSDictionary *) convertToDictionary;
{
    if ([self isEmpty]) return nil;
    NSError *err;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *response = nil;
    if(data != nil){
        response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    return err == nil ? response : nil;
}

- (NSArray *) convertToArrayJson;
{
    if ([self isEmpty]) return [NSArray new];
    NSError *err;
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];;
    if (data == nil) return [NSArray new];

    NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];

    return err == nil ? (results ? results : [NSArray new]) : [NSArray new];
}

- (NSMutableDictionary *) parseQueryToDictionary;
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    @try {
        NSString *tmp = [[self trimWhiteSpace] replaceString:@"?" withString:@""];
        if (![tmp isEmpty]) {
            if ([tmp contains:@"&"]) {
                NSArray *arr = [tmp componentsSeparatedByString:@"&"];
                for (NSString *item in arr) {
                    if ([item contains:@"="]) {
                        NSArray *arr2 = [item componentsSeparatedByString:@"="];
                        if (arr2.count == 2) {
                            [result setObject:[arr2 safeObjectAtIndex:1] forKey:[arr2 safeObjectAtIndex:0]];
                        }
                    }
                }
            } else {
                if ([tmp contains:@"="]) {
                    NSArray *arr2 = [tmp componentsSeparatedByString:@"="];
                    if (arr2.count == 2) {
                        [result setObject:[arr2 safeObjectAtIndex:1] forKey:[arr2 safeObjectAtIndex:0]];
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        
    }
    return result;
}

- (NSString *) removeAccentsText;
{
    NSString *text = self;;
    if ([text contains:@"đ"]) {
        text = [text stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    }
    
    if ([text contains:@"Đ"]) {
        text = [text stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    }
    NSData *asciiEncoded = [text dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    if (asciiEncoded == nil) return text;
    NSString *result = [[NSString alloc] initWithData:asciiEncoded encoding:NSASCIIStringEncoding];
    if (result == nil) return [text replaceString:@"?" withString:@""];
    return result;
}

- (NSString *) parseHTMLString;
{
    NSString *htmlString = self;
    NSError *error;
    //    htmlString = [NSString stringWithFormat:@"<span style=\"font-size:%dpx;color: rgb(90, 100, 135); font-family:-apple-system, Arial, Helvetica, sans-serif;\">%@</span>", LABEL_FONT_DEFAULT, htmlString];
    htmlString = [NSString stringWithFormat:@"<span style=\"font-family:-apple-system, Arial, Helvetica, sans-serif;\">%@</span>", htmlString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:&error];
    
    if (error == nil) {
        return attributedString.string;
    } else {
        return [[NSAttributedString alloc] initWithString:htmlString].string;
    }
}

- (UIColor*) colorWithHexString;
{
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString contains:@"#"]) {
        cString = [cString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    BOOL isTest = YES;
    if (isTest) {
        NSString *temp = [NSString stringWithFormat:@"0x%@", cString];
        NSScanner* pScanner = [NSScanner scannerWithString:temp];
        
        unsigned int iValue;
        [pScanner scanHexInt:&iValue];
        return [UIColor colorWithHex:iValue];
    }
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSString *)indexOfString:(int)position;
{
    if (position > 0) {
        if (position == 1) {
            return [self substringToIndex:position];
        } else if (position == self.length) {
            return [self substringFromIndex:position-1];
        } else {
            if (position < self.length) {
                NSString *t = [self substringToIndex:position];
                return [t substringFromIndex:position-1];
            }
        }
    }
    return @"";
}

- (NSDate *) convert:(NSString *) format;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    @try {
        return [formatter dateFromString:self];
    } @catch (NSException *exception) {
        DLog(@"%@", [exception description]);
    }
    return nil;
}

- (NSDate *) convertUTC:(NSString *) format; //yyyy-MM-dd'T'HH:mm:ss'Z'
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    @try {
        return [formatter dateFromString:self];
    } @catch (NSException *exception) {
        DLog(@"%@", [exception description]);
    }
    return nil;
}

- (NSString *) encodingUTF8;
{
//    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // deprecated
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

- (void) openWebsite;
{
    if (self.length == 0) return;
    NSString *url = self;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
        DLog(@"success: %@", success ? @"YES" : @"NO");
    }];
    
}

- (UIImage *) decodeBase64ToImage;
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (data) return [UIImage imageWithData:data];
    return nil;
}

- (NSMutableAttributedString *) stylingAttributedString:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
{
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithString:self];
    @try {
        NSDictionary *dictText = @{
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color //UITextAttributeTextColor
        };
        
        if ([self rangeOfString:text].location != NSNotFound && text.length > 0) {
            [attContent setAttributes:dictText range:[self rangeOfString:text]];
        }
        return attContent;
    } @catch (NSException *exception) {}
    
    return [[NSMutableAttributedString alloc] initWithString:self];
}

- (NSMutableAttributedString *) stylingAttributedString:(NSString *)text
                                                 color0:(UIColor *)color0
                                                  font0:(UIFont *)font0
                                                  color:(UIColor *)color
                                                   font:(UIFont *)font;
{
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithString:self];
    @try {
        NSDictionary *dictText0 = @{
            NSFontAttributeName : font0,
            NSForegroundColorAttributeName : color0 //UITextAttributeTextColor
        };
        [attContent setAttributes:dictText0 range:NSMakeRange(0, self.length-1)];
        
        NSDictionary *dictText = @{
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color //UITextAttributeTextColor
        };
        
        if ([self rangeOfString:text].location != NSNotFound && text.length > 0) {
            [attContent setAttributes:dictText range:[self rangeOfString:text]];
        }
        return attContent;
    } @catch (NSException *exception) {}
    
    return [[NSMutableAttributedString alloc] initWithString:self];
}

+ (NSString *) randomStringWithLength:(int) len;
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return [self randomStringWithLength:letters len:len];
}

+ (NSString *) randomStringWithLength:(NSString *)letters len:(int) len;
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}
@end
