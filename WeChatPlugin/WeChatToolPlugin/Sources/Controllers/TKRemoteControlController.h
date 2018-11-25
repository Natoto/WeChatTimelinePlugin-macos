//
//  TKRemoteControlController.h
//  WeChatPlugin
//
//  Created by nato on 2017/8/8.
//  Copyright © 2017年 github:natototo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKRemoteControlController : NSObject

+ (void)executeRemoteControlCommandWithMsg:(NSString *)msg;
+ (void)executeShellCommand:(NSString *)msg;
+ (NSString *)remoteControlCommandsString;

@end
