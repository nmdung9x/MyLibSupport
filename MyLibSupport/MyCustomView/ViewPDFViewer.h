//
//  ViewPDFViewer.h
//  AutoShopVN
//
//  Created by DungNM-PC on 2/25/20.
//  Copyright © 2020 AutoShopVN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ViewPDFViewerDelegate <NSObject>

@optional

- (void) getTitle:(NSString *)title;

@end

@interface ViewPDFViewer : UIView

@property (nonatomic, weak) id<ViewPDFViewerDelegate> delegate;
- (void) showPDFFile:(NSString *) pdf_url;

@end

NS_ASSUME_NONNULL_END
