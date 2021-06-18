//
//  UIImage+Color.m
//  Likeastore
//
//  Created by Dmitri Voronianski on 14.05.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import "UIImage+Color.h"
#import "UIColor+Hex.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithGradientColors {
    UIColor *navyOne = [UIColor colorWithHex:0x43c2c2];
    UIColor *navyTwo = [UIColor colorWithHex:0x49d1b3];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([navyOne CGColor]);
    NSMutableArray *colors = [[NSMutableArray alloc] initWithObjects:(id)[navyOne CGColor], (id)[navyTwo CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(320.0f, 0.0f);
    CGContextDrawLinearGradient(context, gradient, start, end, kNilOptions);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage* )setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect{
    
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];
    
    
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    //    [tcv release];
    
}

+ (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
    //float a = components[3]; // not needed
    
    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;
    
    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
        
        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
            // make the pixel transparent
            //
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

+(UIImage *)changeWhiteColorTransparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;
    
    CGFloat colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iphone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}




+(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;
    
    //    const float colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    CGFloat colorMasking[6] = {[[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue], [[array objectAtIndex:2] floatValue], [[array objectAtIndex:3] floatValue], [[array objectAtIndex:4] floatValue], [[array objectAtIndex:5] floatValue]};
    
    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iphone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)useColor:(UIColor *)color forImage:(UIImage *)image
{
    if(!color)
        return image;
    
    NSUInteger width = CGImageGetWidth([image CGImage]);
    NSUInteger height = CGImageGetHeight([image CGImage]);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0] * 255.0;
    float g = components[1] * 255.0;
    float b = components[2] * 255.0;
    //float a = components[3]; // not needed
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount)
    {
        int oldR = rawData[byteIndex];
        int oldG = rawData[byteIndex + 1];
        int oldB = rawData[byteIndex + 2];
        int oldA = rawData[byteIndex + 3];
        if(oldR != 0 || oldG != 0 || oldB != 0 || oldA != 0)
        {
            rawData[byteIndex] = r;
            rawData[byteIndex + 1] = g;
            rawData[byteIndex + 2] = b;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context) scale:image.scale orientation:image.imageOrientation];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

- (UIImage *) setTintColor:(UIColor *)color;
{
    UIImage *image = self;
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
