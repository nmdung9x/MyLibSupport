//
//  LogUtils.m
//  Lounge
//
//  Created by TaHoangMinh on 8/1/14.
//  Copyright (c) 2014 Nguyen Tam Thi. All rights reserved.
//

#import "LogUtils.h"
#import <mach/mach.h>
#import <UIKit/UIKit.h>
#import "NSDate+Utils.h"
//#import "CrashManager.h"

#define buttonDebugY 20
#define buttonDebugWidth 60
#define buttonDebugHeight 30
#define buttonDebugFontSize 12

@implementation LogUtils
static UIButton *btnFull = nil;
static UIButton *btnDebugMode = nil;
static UIButton *btnClearLog = nil;
static UIButton *btnSendLogMode = nil;
static UIButton *btnScrollDown = nil;
static UILabel *lblMemoryLog = nil;
static NSMutableString * strDebugMode = nil;
static UITextView *tvDebugMode = nil;
static NSFileHandle *fileDebug = nil;
static NSFileHandle *fileCrash = nil;

static id instance = nil;
static id _shareInstance = nil;

static int DEBUG_MODE = 1;
static int DEBUG_SCREEN = 0; // 1 = show on screen, 2 = log into file, 3 = both
static int DEBUG_MEMORY = 0;

+ (LogUtils *) shareInstance;
{
    if (_shareInstance == nil) {
        _shareInstance = [[LogUtils alloc] init];
    }
    return _shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (DEBUG_MEMORY == 1){
            self.timerMemory = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkMemory) userInfo:nil repeats:YES];
        }
    }
    return self;
}

#pragma mark DEBUG MODE

- (void) checkMemory
{
    report_memory();
}

- (void) logMemory:(NSString *) str
{
    if (DEBUG_MEMORY == 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            if (lblMemoryLog == nil) {
                lblMemoryLog = [[UILabel alloc] initWithFrame:CGRectMake(200, buttonDebugY, buttonDebugWidth * 2, buttonDebugHeight)];
                lblMemoryLog.font = [UIFont systemFontOfSize:buttonDebugFontSize];
                lblMemoryLog.backgroundColor = [UIColor redColor];
                lblMemoryLog.textColor = [UIColor whiteColor];
                [window addSubview:lblMemoryLog];
            } else {
                [window bringSubviewToFront:btnDebugMode];
            }
            lblMemoryLog.text = str;
        });
    }
}

void report_memory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        float sizeInMB = (double)info.resident_size / 1024.0f / 1024.0f;
        [[LogUtils shareInstance] logMemory:[NSString stringWithFormat:@"memory in MB: %.2f", sizeInMB]];
    } else {
        [[LogUtils shareInstance] logMemory:[NSString stringWithFormat:@"%s", mach_error_string(kerr)]];
        
    }
}

+ (void) logLine:(int)line
        function:(NSString *)function
         content:(NSString *)content;
{
    NSString *datetime = [[NSDate date] stringWithFormat:@"dd-MM-yyyy_HH:mm:ss"];
    NSString *strDebug = [NSString stringWithFormat:@"[%@ %@] %@ [%d]: %@", @"LOG", datetime, function, line, content, nil];
    if (app_stage == 0 && DEBUG_SCREEN == 0) DEBUG_SCREEN = 1;
    if (DEBUG_MODE == 1){
        NSLog(@"[%@] %@ [%d]: %@", datetime, function, line, content);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (DEBUG_MODE == 1){
            [strDebugMode appendFormat:@"\n %@", strDebug];
        }
        
        if (DEBUG_MODE == 1 && (DEBUG_SCREEN == 1 || DEBUG_SCREEN == 3)){
            [self addDebugScreen];
        }
        if (DEBUG_MODE == 1){
            if (tvDebugMode.hidden == NO) {
                tvDebugMode.text = strDebugMode;
            }
        }
        
        if (DEBUG_MODE == 1 && (DEBUG_SCREEN == 2 || DEBUG_SCREEN == 3)){
            [self addDebugFile];
            [fileDebug writeData:[[NSString stringWithFormat:@"\n\n%@", strDebug] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        if (tvDebugMode && !tvDebugMode.hidden) {
            [self logScrollToBottom];
        }
    });
}

+ (void) log: (NSString *) content;
{
    NSString *datetime = [[NSDate date] stringWithFormat:@"dd-MM-yyyy_HH:mm:ss"];
    NSLog(@"[%@] : %@", datetime, content);
}

+ (void) logAPIRequest: (NSURLRequest *)path withParams: (NSDictionary *) params;
{
    if (DEBUG_MODE == 1){
        DLogAPI(@"Request API: %@ params: %@", path.URL.absoluteString, [params description]);
    }
}

+ (void) logAPIResponse: (NSURLResponse *)path withResponse: (NSDictionary *) response;
{
    if (DEBUG_MODE == 1){
        DLogAPI(@"Response from server API: %@ data: %@", path.URL.absoluteString, [response description]);
    }
}
+ (void) logError:(NSURLRequest *)path withError:(NSError *)error;
{
    if (DEBUG_MODE == 1){
        DLogAPI(@"***ERROR***: %@ data: %@", path.URL.absoluteString, [error localizedDescription]);
    }
}
+ (void) addDebugFile
{
    if (fileDebug == nil) {
        //Get the file path
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) safeObjectAtIndex:0];
        NSLog(@"DOCUMENT PATH: %@", documentsDirectory);
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"debug_log.txt"];
        
        //create file if it doesn't exist
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        }
        
        //append text to file (you'll probably want to add a newline every write)
        fileDebug = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
        [fileDebug writeData:[[self getInfoModelDevice] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void) addDebugCrash
{
    if (fileCrash == nil) {
        //Get the file path
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) safeObjectAtIndex:0];
        NSLog(@"DOCUMENT PATH: %@", documentsDirectory);
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"crash_log.txt"];
        
        //create file if it doesn't exist
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        }
        
        //append text to file (you'll probably want to add a newline every write)
        fileCrash = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
        [fileCrash writeData:[[LogUtils getInfoModelDevice] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

+ (void) addDebugScreen
{
    if (app_stage == 0 && DEBUG_MODE == 0) DEBUG_MODE = 1;
    if (DEBUG_MODE == 1 || DEBUG_SCREEN == 3){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            if (btnDebugMode == nil) {
                instance = [[LogUtils alloc] init];
                strDebugMode = [[NSMutableString alloc] init];
                
                // add debug button
                btnDebugMode = [[UIButton alloc] init];
                [btnDebugMode setBackgroundColor:[UIColor redColor]];
                btnDebugMode.frame = CGRectMake(60, buttonDebugY, buttonDebugWidth, buttonDebugHeight);
                [btnDebugMode.titleLabel setFont:[UIFont systemFontOfSize:buttonDebugFontSize]];
                [btnDebugMode setTitle:@"DEBUG" forState:UIControlStateNormal];
                btnDebugMode.alpha = 0.6f;
                [window addSubview:btnDebugMode];
                [btnDebugMode addTarget:instance action:@selector(btnDebugModeClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                // add clear button
                btnClearLog = [[UIButton alloc] init];
                [btnClearLog setBackgroundColor:[UIColor redColor]];
                btnClearLog.frame = CGRectMake(btnDebugMode.frame.origin.x + btnDebugMode.frame.size.width + 10, buttonDebugY, buttonDebugWidth, buttonDebugHeight);
                [btnClearLog.titleLabel setFont:[UIFont systemFontOfSize:buttonDebugFontSize]];
                [btnClearLog setTitle:@"CLEAR" forState:UIControlStateNormal];
                [window addSubview:btnClearLog];
                btnClearLog.hidden = YES;
                [btnClearLog addTarget:instance action:@selector(btnClearDebugClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                // add send log mode
                btnSendLogMode = [[UIButton alloc] init];
                [btnSendLogMode setBackgroundColor:[UIColor redColor]];
                btnSendLogMode.frame = CGRectMake(btnClearLog.frame.origin.x + btnClearLog.frame.size.width + 10, buttonDebugY, buttonDebugWidth, buttonDebugHeight);
                [btnSendLogMode.titleLabel setFont:[UIFont systemFontOfSize:buttonDebugFontSize]];
                [btnSendLogMode setTitle:@"SENDLOG" forState:UIControlStateNormal];
                btnSendLogMode.hidden = YES;
                [window addSubview:btnSendLogMode];
                [btnSendLogMode addTarget:instance action:@selector(btnSendDebugClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                // add scroll down
                btnScrollDown = [[UIButton alloc] init];
                [btnScrollDown setBackgroundColor:[UIColor redColor]];
                btnScrollDown.frame = CGRectMake(btnSendLogMode.frame.origin.x + btnSendLogMode.frame.size.width + 10, buttonDebugY, buttonDebugWidth+buttonDebugHeight, buttonDebugHeight);
                [btnScrollDown.titleLabel setFont:[UIFont systemFontOfSize:buttonDebugFontSize]];
                [btnScrollDown setTitle:@"SCROLL DOWN" forState:UIControlStateNormal];
                btnScrollDown.hidden = YES;
                [window addSubview:btnScrollDown];
                [btnScrollDown addTarget:instance action:@selector(btnScrollDownClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                //add full screen
                btnFull = [[UIButton alloc] init];
                [btnFull setBackgroundColor:[UIColor redColor]];
                btnFull.frame = CGRectMake(10, buttonDebugY, buttonDebugHeight+10, buttonDebugHeight);
                [btnFull.titleLabel setFont:[UIFont systemFontOfSize:buttonDebugFontSize]];
                [btnFull setTitle:@"FULL" forState:UIControlStateNormal];
                btnFull.hidden = YES;
                [window addSubview:btnFull];
                [btnFull addTarget:instance action:@selector(btnFullClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                tvDebugMode = [[UITextView alloc] init];
                [tvDebugMode setEditable:NO];
                [tvDebugMode setBackgroundColor:[UIColor blackColor]];
                [tvDebugMode setTextColor:[UIColor whiteColor]];
                [window addSubview:tvDebugMode];
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    tvDebugMode.frame = CGRectMake(10, buttonDebugY + buttonDebugHeight + 10, 710, 1000 - (buttonDebugY + buttonDebugHeight + 10));
                } else {
                    tvDebugMode.frame = CGRectMake(10, buttonDebugY + buttonDebugHeight + 10, 310, 480 - (buttonDebugY + buttonDebugHeight + 10));
                }
                
                
                tvDebugMode.layer.borderColor = [UIColor redColor].CGColor;
                tvDebugMode.layer.borderWidth = 1.0f;
                tvDebugMode.hidden = YES;
            } else {
                [window bringSubviewToFront:btnFull];
                [window bringSubviewToFront:btnDebugMode];
                [window bringSubviewToFront:btnClearLog];
                [window bringSubviewToFront:tvDebugMode];
                [window bringSubviewToFront:btnSendLogMode];
                [window bringSubviewToFront:btnScrollDown];
            }
        });
    }
}

- (void) btnFullClicked:(UIButton *) sender;
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if ([sender.titleLabel.text isEqualToString:@"FULL"]) {
        [sender setTitle:@"MIN" forState:UIControlStateNormal];
        tvDebugMode.frame = CGRectMake(0, buttonDebugY + buttonDebugHeight + 10, window.frame.size.width, window.frame.size.height - (buttonDebugY + buttonDebugHeight + 10));
    } else {
        [sender setTitle:@"FULL" forState:UIControlStateNormal];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            tvDebugMode.frame = CGRectMake(10, buttonDebugY + buttonDebugHeight + 10, 710, 1000 - (buttonDebugY + buttonDebugHeight + 10));
        } else {
            tvDebugMode.frame = CGRectMake(10, buttonDebugY + buttonDebugHeight + 10, 310, 480 - (buttonDebugY + buttonDebugHeight + 10));
        }
    }
}

- (void) btnDebugModeClicked:(id) sender;
{
    tvDebugMode.hidden = !tvDebugMode.hidden;
    
    btnFull.hidden = tvDebugMode.hidden;
    btnClearLog.hidden = tvDebugMode.hidden;
    btnSendLogMode.hidden = tvDebugMode.hidden;
    btnScrollDown.hidden = tvDebugMode.hidden;
    if (tvDebugMode.hidden == NO) {
        tvDebugMode.text = strDebugMode;
    }
}

- (void) btnClearDebugClicked:(id) sender;
{
    tvDebugMode.text = @"";
    strDebugMode = [[NSMutableString alloc] init];
}

-(void) btnSendDebugClicked:(UIButton*)sender;
{
    [self sendLogToServer];
    tvDebugMode.hidden = YES;
    
    btnFull.hidden = tvDebugMode.hidden;
    btnClearLog.hidden = tvDebugMode.hidden;
    btnSendLogMode.hidden = tvDebugMode.hidden;
    btnScrollDown.hidden = tvDebugMode.hidden;
}

- (void) btnScrollDownClicked:(UIButton*)sender;
{
    if (tvDebugMode && tvDebugMode.text.length > 0) {
        NSRange bottom = NSMakeRange(tvDebugMode.text.length -1, 1);
        [tvDebugMode scrollRangeToVisible:bottom];
    }
}

+ (void) logScrollToBottom;
{
    if (tvDebugMode && tvDebugMode.text.length > 0) {
        NSRange bottom = NSMakeRange(tvDebugMode.text.length -1, 1);
        [tvDebugMode scrollRangeToVisible:bottom];
    }
    
}

- (void) sendMail:(NSString *)subject content:(NSString *)content;
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:subject];
        [mail setMessageBody:content isHTML:NO];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window.rootViewController presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)deleteFileLogDebugWithFileName:(NSString *)fileName
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:fileName error:&error];
    fileDebug = nil;
    return YES;
}

-(void)sendLogToServer
{
    NSString *strLogData = strDebugMode;
    if (strLogData == nil) {
        strLogData = @"";
    }
    
    [self sendMail:[LogUtils getInfoModelDevice] content:strLogData];
    
    [self sendLog:strLogData completeBlock:^(BOOL result, NSString *error) {
        if (result) {
            tvDebugMode.text = @"";
            strDebugMode = [[NSMutableString alloc] init];
        }
    }];
}

-(void) sendLogFileToServer;
{
    //    UIDevice *aDevice = [UIDevice currentDevice];
    //    deviceName = [[aDevice name] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    //
    //    NSString *strLogData = strDebugMode;
    //    if (strLogData == nil) {
    //        strLogData = @"";
    //    }
    //    if (DEBUG_MODE == 1){
    //        [self sendCrashLog];
    //
    //        NSString *bundleIdentifier = [NSString stringWithFormat:@"ios_%@", [[NSBundle mainBundle] bundleIdentifier]];;
    //        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"debug_log.txt"];
    //        //create file if it doesn't exist
    //        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    //            NSData *logData = [NSData dataWithContentsOfFile:filePath];
    //
    //            NSString *dateCurrentString = [Utils formatDateTime:[NSDate date] dateFormat:@"dd.MM.yyyy_HH:mm:ss"];
    //            if (deviceName == nil) {
    //                deviceName = @"";
    //            }
    //            NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@", bundleIdentifier, deviceName, dateCurrentString];
    //
    //            [self checklog:bundleIdentifier status:@"" completeBlock:^(NSString *result, NSString *error) {
    //                if ([result isEqualToString:@"1"]) {
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 2;//log into file
    //                    DEBUG_MEMORY = 0;
    //                    [self sendLogFile:fileName content:logData completeBlock:^(BOOL result, NSString *error) {
    //                        [self deleteFileLogDebugWithFileName:filePath];
    //                    }];
    //                } else if ([result isEqualToString:@"3"]) { //for IOS
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 3;//log into file and show in screen
    //                    DEBUG_MEMORY = 0;
    //                    [self sendLogFile:fileName content:logData completeBlock:^(BOOL result, NSString *error) {
    //                        [self deleteFileLogDebugWithFileName:filePath];
    //                    }];
    //                } else if ([result isEqualToString:@"4"]) { //for IOS
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 3;//log into file and show in screen
    //                    DEBUG_MEMORY = 1;// show log memory
    //                    [self sendLogFile:fileName content:logData completeBlock:^(BOOL result, NSString *error) {
    //                        [self deleteFileLogDebugWithFileName:filePath];
    //                    }];
    //                } else if ([result isEqualToString:@"2"]) {
    //                    DEBUG_MODE = 0;
    //                    DEBUG_SCREEN = 0;
    //                    DEBUG_MEMORY = 0;
    //                    [self deleteFileLogDebugWithFileName:fileName];
    //                } else {
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 0;
    //                    DEBUG_MEMORY = 0;
    //                    [self deleteFileLogDebugWithFileName:fileName];
    //                }
    //            }];
    //        } else {
    //            [self checklog:bundleIdentifier status:@"" completeBlock:^(NSString *result, NSString *error) {
    //                if ([result isEqualToString:@"1"]) {
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 2;//log into file
    //                    DEBUG_MEMORY = 0;
    //                } else if ([result isEqualToString:@"3"]) { //for IOS
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 3;//log into file and show in screen
    //                    DEBUG_MEMORY = 0;
    //                } else if ([result isEqualToString:@"4"]) { //for IOS
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 3;//log into file and show in screen
    //                    DEBUG_MEMORY = 1;// show log memory
    //                } else if ([result isEqualToString:@"2"]) {
    //                    DEBUG_MODE = 0;
    //                    DEBUG_SCREEN = 0;
    //                    DEBUG_MEMORY = 0;
    //                } else {
    //                    DEBUG_MODE = 1;
    //                    DEBUG_SCREEN = 0;
    //                    DEBUG_MEMORY = 0;
    //                }
    //            }];
    //        }
    //    }
}


- (void) sendCrashLog;
{
    /*
     NSString* errorReport = [CrashManager sharedInstance].errorReport;
     if (errorReport !=nil){
     if ([errorReport isEqualToString:@""]) {
     return;
     }
     NSString *bundleIdentifier = [NSString stringWithFormat:@"ios_%@", [[NSBundle mainBundle] bundleIdentifier]];;
     NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
     NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"crash_log.txt"];
     
     [self addDebugCrash];
     [fileCrash writeData:[[NSString stringWithFormat:@"\n\n%@", errorReport] dataUsingEncoding:NSUTF8StringEncoding]];
     NSData *logData = [NSData dataWithContentsOfFile:filePath];
     [[CrashManager sharedInstance] deleteErrorReport];
     
     NSString *dateCurrentString = [Utils formatDateTime:[NSDate date] dateFormat:"dd.MM.yyyy_HH:mm:ss"];;
     if (deviceName == nil) {
     deviceName = @"";
     }
     NSString *fileName = [NSString stringWithFormat:@"_crash_%@_%@_%@", bundleIdentifier, deviceName ,dateCurrentString];
     fileName = [fileName stringByReplacingOccurrencesOfString:@"'" withString:@""];
     [self sendLogFile:fileName content:logData completeBlock:^(BOOL result, NSString *error) {
     [self deleteFileLogDebugWithFileName:filePath];
     }];
     }
     */
}

static NSString *deviceName = @"";
+(NSString*)getInfoModelDevice
{
    UIDevice *aDevice = [UIDevice currentDevice];
    NSMutableArray *passingArray = [[NSMutableArray alloc] initWithCapacity:5];
    [passingArray addObject: [aDevice model]];
    [passingArray addObject: [aDevice name]];
    [passingArray addObject: [aDevice localizedModel]];
    [passingArray addObject: [aDevice systemName]];
    [passingArray addObject: [aDevice systemVersion]];
    
    deviceName = [[aDevice name] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    
    NSString *modelDevice = [NSString stringWithFormat:@"Model: %@ \nName: %@ \nLocalizedModel: %@ \nSystemName: %@ \nSystemVersion: %@\n", passingArray[0], passingArray[1], passingArray[2], passingArray[3], passingArray[4]];
    return modelDevice;
    
}

-(void)checklog:(NSString *)name status:(NSString *)status completeBlock:(void (^)(NSString *result, NSString *error))block;
{
    //    NSString *time = [Utils formatDateTime:[NSDate date] dateFormat:@"dd-MM-yyyy HH:mm:ss"];;
    //
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{@"name":name, @"status":status, @"note":time}];
    //
    //    [[Net sharedInstance] POST:@"http://quanlyhangxe.com/shorashim/log/index.php/api/setlogproject" params:param completeBlock:^(bool isSuccess, id responseObject, NSString *error) {
    //        if (isSuccess) {
    //            if ([responseObject objectForKey:@"code"] != nil) {
    //                int code = [[responseObject objectForKey:@"code"] intValue];
    //                if (code == 1) {
    //                    NSDictionary *data = [responseObject objectForKey:@"result"];
    //                    NSString *status = data[@"status"];
    //                    if (status == nil) {
    //                        status = @"0";
    //                    }
    //                    block(status, @"");
    //                    return;
    //                }
    //            }
    //            block(@"0", @"");
    //        } else {
    //            block(@"0", error);
    //        }
    //    }];
    
}

-(void)sendLog:(NSString *)content completeBlock:(void (^)(BOOL result, NSString *error))block;
{
    NSString *bundleIdentifier = [NSString stringWithFormat:@"ios_%@", [[NSBundle mainBundle] bundleIdentifier]];;
    
    NSString *dateCurrentString = [[NSDate date] stringWithFormat:@"dd.MM.yyyy"];
    UIDevice *aDevice = [UIDevice currentDevice];
    deviceName = [[aDevice name] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    if (deviceName == nil) {
        deviceName = @"";
    }
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@", bundleIdentifier, deviceName, dateCurrentString];
    [self sendLog:fileName content:content completeBlock:block];
}

-(void)sendLog:(NSString *)filename content:(NSString *)content completeBlock:(void (^)(BOOL result, NSString *error))block;
{
    //    filename = [filename stringByReplacingOccurrencesOfString:@"'" withString:@""];
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{@"filename":filename, @"content":content}];
    //
    //    [[Net sharedInstance] POST:@"http://quanlyhangxe.com/shorashim/log/onlinelog/zrecordlog.php" params:param completeBlock:^(bool isSuccess, id responseObject, NSString *error) {
    //        if (isSuccess) {
    //            if ([responseObject objectForKey:@"code"] != nil) {
    //                int code = [[responseObject objectForKey:@"code"] intValue];
    //                if (code == 1) {
    //                    block(YES, @"");
    //                    return;
    //                }
    //            }
    //            block(NO, @"");
    //        } else {
    //            block(NO, error);
    //        }
    //    }];
}

-(void) sendLogFile:(NSString *)filename content:(NSData *)content completeBlock:(void (^)(BOOL result, NSString *error))block;
{
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"filename" : filename}];
    //
    //    NSMutableArray *files = [NSMutableArray new];
    //    FileData *file = [[FileData alloc] init];
    //    file.key = @"file";
    //    file.name = [NSString stringWithFormat:@"%@.log", filename];
    //    file.mimeType = @"file/*";
    //    file.content = content;
    //    [files addObject:file];
    //
    //    [[Net sharedInstance] POST2:@"http://quanlyhangxe.com/shorashim/log/index.php/api/uploadlog" params:param files:files completeBlock:^(bool isSuccess, id responseObject, NSString *error) {
    //        if (isSuccess) {
    //            if ([responseObject objectForKey:@"code"] != nil) {
    //                int code = [[responseObject objectForKey:@"code"] intValue];
    //                if (code == 1) {
    //                    block(YES, @"");
    //                    return;
    //                }
    //            }
    //            block(NO, @"");
    //        } else {
    //            block(NO, error);
    //        }
    //    }];
}



@end
