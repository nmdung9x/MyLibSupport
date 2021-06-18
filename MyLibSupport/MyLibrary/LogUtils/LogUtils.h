//
//  LogUtils.h
//  Lounge
//
//  Created by TaHoangMinh on 8/1/14.
//  Copyright (c) 2014 Nguyen Tam Thi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

//#define DEBUG_MODE 1
//#define DEBUG_SCREEN 2 // 1 = show on screen, 2 = log into file, 3 = both
//#define DEBUG_MEMORY 0
#undef DLog
#define DLog(fmt, ...)\
[LogUtils logLine:__LINE__ function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] content:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]

#define DLogSocket(fmt, ...)\
[LogUtils logLine:__LINE__ function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] content:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]

#define DLogAPI(fmt, ...)\
[LogUtils logLine:__LINE__ function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] content:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]

#define DLogDB(fmt, ...)\
[LogUtils logLine:__LINE__ function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] content:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]

#define ELog(err)

@interface LogUtils : NSObject <MFMailComposeViewControllerDelegate>
{
    
}
@property NSTimer *timerMemory;
+ (LogUtils *) shareInstance;
+ (void) logLine:(int)line
        function:(NSString *)function
         content:(NSString *)content;
+ (void) log: (NSString *) content;
+ (void) logAPIRequest: (NSURLRequest *)path withParams: (NSDictionary *) params;
+ (void) logAPIResponse: (NSURLResponse *)path withResponse: (NSDictionary *) response;
+ (void) logError:(NSURLRequest *)path withError:(NSError *)error;
+ (NSString*) getInfoModelDevice;
//-(void) sendLogToServer;
-(void) sendLogFileToServer;
-(void) sendLog:(NSString *)content completeBlock:(void (^)(BOOL result, NSString *error))block;
-(void) sendLog:(NSString *)filename content:(NSString *)content completeBlock:(void (^)(BOOL result, NSString *error))block;
-(void) sendLogFile:(NSString *)filename content:(NSData *)content completeBlock:(void (^)(BOOL result, NSString *error))block;
@end

