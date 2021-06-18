//
//  PopupCustomViewController.m
//  DMS
//
//  Created by NMD9x on 12/29/18.
//  Copyright © 2018 NMD9x. All rights reserved.
//

#import "PopupCustomViewController.h"
#import "UIView+Utils.h"

@interface PopupCustomViewController () {
    UIView *viewRoot;
}

@end

@implementation PopupCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    viewRoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthV, self.view.frame.size.height)];
    viewRoot.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewRoot];
}

- (void) setCustomView:(UIView *)viewContent;
{
    if (viewContent) {
        [viewRoot addSubview:viewContent];
        viewRoot.height = viewContent.height;
    }
}

- (void) closeView;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
