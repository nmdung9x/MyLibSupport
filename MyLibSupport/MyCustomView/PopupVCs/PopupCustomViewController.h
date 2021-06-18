//
//  PopupCustomViewController.h
//  DMS
//
//  Created by NMD9x on 12/29/18.
//  Copyright © 2018 NMD9x. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PopupCustomViewControllerDelegate;

@interface PopupCustomViewController : UIViewController

@property (nonatomic) NSInteger tagVC;
@property (nonatomic) CGFloat widthV;

@property (nonatomic, weak) id<PopupCustomViewControllerDelegate> delegate;

- (void) setCustomView:(UIView *)viewContent;
- (void) closeView;

@end

@protocol PopupCustomViewControllerDelegate <NSObject>

@optional

- (void)selectItem:(PopupCustomViewController *)popup dic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
