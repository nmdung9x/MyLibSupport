//
//  ViewPDFViewer.m
//  AutoShopVN
//
//  Created by DungNM-PC on 2/25/20.
//  Copyright © 2020 AutoShopVN. All rights reserved.
//

#import "ViewPDFViewer.h"
#import <WebKit/WebKit.h>

#import "UIView+Utils.h"
#import "NSString+Utils.h"

@import PDFKit;

@interface ViewPDFViewer () <WKNavigationDelegate, PDFViewDelegate> {
    WKWebView *viewWeb;
    
    PDFView *pdfView;
}

@end

@implementation ViewPDFViewer

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView:frame];
    }
    return self;
}


- (void) loadView:(CGRect) frame;
{
    if (@available(iOS 11.0, *)) {
        pdfView = [[PDFView alloc]initWithFrame:frame];
        [self addSubview:pdfView];
        pdfView.hidden = YES;
        
        pdfView.delegate = self;
        pdfView.autoScales = true;
        pdfView.displayMode = kPDFDisplaySinglePageContinuous;
    } else {
        WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
        viewWeb = [[WKWebView alloc] initWithFrame:frame configuration:theConfiguration];
        viewWeb.navigationDelegate = self;
        [self addSubview:viewWeb];
        viewWeb.hidden = YES;
        
        viewWeb.scrollView.bounces = NO;
        
        CGFloat sizeBtn = 60;
        UIView *viewClick = [[UIView alloc] initWithFrame:CGRectMake(self.width - sizeBtn, 0, sizeBtn, sizeBtn)];
        viewClick.backgroundColor = [UIColor clearColor];
        [self addSubview:viewClick];
        [self bringSubviewToFront:viewClick];
        [viewClick addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClicked)]];
    }
}

static bool testing = false;
- (void) showPDFFile:(NSString *) pdf_url;
{
    viewWeb.hidden = YES;
    pdfView.hidden = YES;
    
    if (@available(iOS 11.0, *)) {
        PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:[NSURL URLWithString:[pdf_url encodingUTF8]]];
        pdfView.document = pdfDocument;
        if (pdfDocument.isEncrypted) {
            //                [Utils showToast:@"File PDF bị mã hoá!"];
            //                NSString *pdf_password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pdf_password"];
            //                if (pdf_password == nil) pdf_password = @"";
            //                [self->pdfView.document unlockWithPassword:pdf_password];
        }
        pdfView.hidden = NO;
    } else {
        viewWeb.hidden = NO;
        [viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[pdf_url encodingUTF8]]]];
    }
}

- (BOOL) isEncrypted;
{
    if (pdfView) return pdfView.document.isEncrypted;
    return NO;
}

- (void) btnClicked;
{
    
}
@end
