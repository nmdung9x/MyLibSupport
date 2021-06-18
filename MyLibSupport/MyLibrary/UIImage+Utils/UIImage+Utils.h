//
//  UIImage+Utils.h
//  MyLibSupport
//
//  Created by DungNM-PC on 18/06/2021.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

- (NSString *) encodePNGToBase64String;
- (NSString *) encodeJPGToBase64String:(CGFloat) compressionQuality;

@end

NS_ASSUME_NONNULL_END
