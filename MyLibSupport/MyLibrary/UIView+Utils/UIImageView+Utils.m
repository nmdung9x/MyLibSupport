//
//
//  Created by Dmitri Voronianski on 14.05.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import "UIImageView+Utils.h"
#import "UIView+Utils.h"

@implementation UIImageView (Utils)

- (CGFloat) calcHeight:(UIImage *) image;
{
    CGFloat result = 0;
    if (image) {
        result = self.width * image.size.height / image.size.width;
        if (isnan(result)) return 0;
    }
    
    return result;
}

- (CGFloat) calcWidth:(UIImage *) image;
{
    CGFloat result = 0;
    if (image) {
        result = self.height * image.size.width/image.size.height;
        if (isnan(result)) return 0;
    }
    return result;
}

- (CGFloat) calcHeight;

{
    return [self calcHeight:self.image];
}

- (CGFloat) calcWidth;
{
    return [self calcWidth:self.image];
}

- (NSString *) encodeToBase64String;
{
    return [UIImagePNGRepresentation(self.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *) setImageTintColor:(UIColor *)color;
{
    UIImage *image = self.image;
    UIImage *newImage = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newImage;
    return newImage;
}

@end
