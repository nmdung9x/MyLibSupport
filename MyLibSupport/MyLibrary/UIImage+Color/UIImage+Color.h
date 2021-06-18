//
//  UIImage+Color.h
//  Likeastore
//
//  Created by Dmitri Voronianski on 14.05.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithGradientColors;

+ (UIImage*)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect;

+ (UIImage*)replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;

+ (UIImage *)useColor:(UIColor *)color forImage:(UIImage *)image;

+(UIImage *)changeWhiteColorTransparent:(UIImage *)image;

+(UIImage *)changeColorTo:(NSMutableArray*)array Transparent:(UIImage *)image;

//resizing Stuff...
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIImage *) setTintColor:(UIColor *)color;
@end
