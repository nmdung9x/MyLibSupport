//
//  DateTimePickerView.h
//  Sapo 360
//
//  Created by DungNM-PC on 24/05/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateTimePickerView : UIView {
    void(^ _block)(NSDate * _Nullable date, BOOL isClear);
}

@property (nonatomic) NSString *strTitle;
@property (nonatomic) NSString *btnLeftTitle;
@property (nonatomic) NSString *btnRightTitle;

@property (nonatomic) NSDate *defaultDate;
@property (nonatomic) NSDate *minDate;
@property (nonatomic) NSDate *maxDate;

@property (nonatomic) BOOL showTimePicker;

- (void) initView;
- (void) completeSelectItem:(void(^)(NSDate * _Nullable date, BOOL isClear)) block;

@end

NS_ASSUME_NONNULL_END
