//
//  DateTimePickerView.m
//  Sapo 360
//
//  Created by DungNM-PC on 24/05/2021.
//

#import "DateTimePickerView.h"

#import "UIView+Utils.h"

@interface DateTimePickerView () {
    UIView *viewTitle;
    UIButton *btnLeft, *btnRight;
    UILabel *lblTitle;
    UIView *viewContent;
    UIDatePicker *datePicker;
}

@end

@implementation DateTimePickerView

- (id) initWithFrame:(CGRect) frame {
    return [super initWithFrame:frame];
}

- (void) initView;
{
    viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self addSubview:viewTitle];
    
    CGFloat btnWidth = 80;
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, viewTitle.height)];
    [btnLeft setTitle:_btnLeftTitle ? _btnLeftTitle : @"Hủy" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(btnLeftClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewTitle addSubview:btnLeft];
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(viewTitle.right - btnWidth, 0, btnWidth, viewTitle.height)];
    [btnRight setTitle:_btnRightTitle ? _btnRightTitle : @"Xong" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewTitle addSubview:btnRight];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(btnLeft.right, 0, btnRight.left - btnLeft.right, viewTitle.height)];
    lblTitle.text = _strTitle ? _strTitle : (_showTimePicker ? @"Chọn giờ phút" : @"Chọn ngày tháng");
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [viewTitle addSubview:lblTitle];
    
    viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, viewTitle.bottom, self.width, 0)];
    [self addSubview:viewContent];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, viewContent.width, 400)];
    [viewContent addSubview:datePicker];
    viewContent.height = datePicker.height;

    if (_showTimePicker) {
        datePicker.datePickerMode = UIDatePickerModeTime;
        if (_defaultDate) datePicker.date = _defaultDate;
        if (@available(iOS 13.4, *)) {
            [datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
        }
    } else {
        if (_minDate) datePicker.minimumDate = _minDate;
        if (_maxDate) datePicker.maximumDate = _maxDate;
        if (_defaultDate) datePicker.date = _defaultDate;
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        if (@available(iOS 14.0, *)) {
            [datePicker setPreferredDatePickerStyle:UIDatePickerStyleInline];
        } else {
            if (@available(iOS 13.4, *)) {
                [datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
            }
        }
    }
    
    [datePicker sizeToFit];
    
    datePicker.width = datePicker.bounds.size.width;
    datePicker.height = datePicker.bounds.size.height;
    datePicker.left = viewContent.width/2 - datePicker.width/2;
    viewContent.height = datePicker.height;
    
    self.height = viewContent.bottom;
}

- (void) completeSelectItem:(void(^)(NSDate * _Nullable date, BOOL isClear)) block;
{
    _block = block;
}


- (void) btnLeftClicked:(UIButton *) sender;
{
    [sender animationScale:0.9 completion:^{
        self->_block(nil, YES);
    }];
}

- (void) btnRightClicked:(UIButton *) sender;
{
    [sender animationScale:0.9 completion:^{
        self->_block(self->datePicker.date, NO);
    }];
}

@end
