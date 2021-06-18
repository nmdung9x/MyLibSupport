//
//
//  Created by Dmitri Voronianski on 14.05.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (Utils)

- (CGFloat) calcHeight:(UIImage *) image;
- (CGFloat) calcWidth:(UIImage *) image;
- (CGFloat) calcHeight;
- (CGFloat) calcWidth;
- (NSString *) encodeToBase64String;
- (UIImage *) setImageTintColor:(UIColor *)color;

@end
