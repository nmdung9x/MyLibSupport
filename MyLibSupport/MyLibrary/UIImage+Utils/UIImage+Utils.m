//
//  UIImage+Utils.m
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

- (NSString *) encodeJPGToBase64String:(CGFloat) compressionQuality;
{
    return [UIImageJPEGRepresentation(self, compressionQuality) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *) encodePNGToBase64String;
{
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
