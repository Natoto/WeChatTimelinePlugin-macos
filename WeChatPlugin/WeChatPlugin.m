//
//  WeChatPlugin.m
//  WeChatPlugin
//
//  Created by nato on 2017/1/22.
//  Copyright (c) 2017年 github:natoto. All rights reserved.
//

#import "WeChatPlugin.h"
#import "WeChatPluginHeader.h"
#import "MMTimeLineMainViewController.h"
#import "MMTimeLineViewController.h"
#import "WeChat+hook.h"
#import "MMChatsTableCellView+hook.h"


#pragma mark - Plugin

@implementation NSBundle (WeChatPlugin)

+ (instancetype)pluginBundle {
    return [NSBundle bundleWithIdentifier:@"com.corbin.WeChatPlugin"];
}

@end

@implementation NSObject (WeChatPlugin)

#pragma mark - MMLogger

+ (void)cb_logWithMMLogLevel:(int)arg1 module:(const char *)arg2 file:(const char *)arg3 line:(int)arg4 func:(const char *)arg5 message:(id)arg6 {
    NSLog(@"[%s] %s %s %@", arg2, arg3, arg5, arg6);
}

#pragma mark - MMCGIConfig

- (const struct MMCGIItem *)cb_findItemWithFuncInternal:(int)arg1 {
    struct MMCGIItem *res = (struct MMCGIItem *)[self cb_findItemWithFuncInternal:arg1];
    if (arg1 == kMMCGIWrapTimeLineFunctionId) {
        res = malloc(sizeof(struct MMCGIItem));
        res->_field1 = kMMCGIWrapTimeLineFunctionId;
        res->_field2 = 0;
        res->_field3 = 0;
        res->_field4 = "mmsnstimeline";
        res->_field5 = CBGetClass(SnsTimeLineResponse);
        res->_field6 = 1;
        res->_field7 = 2;
        res->_field8 = 0;
    }
    else if (arg1 == kMMCGIWrapHomePageFunctionId) {
        res = malloc(sizeof(struct MMCGIItem));
        res->_field1 = kMMCGIWrapHomePageFunctionId;
        res->_field2 = 0;
        res->_field3 = 0;
        res->_field4 = "mmsnsuserpage";
        res->_field5 = CBGetClass(SnsUserPageResponse);
        res->_field6 = 1;
        res->_field7 = 2;
        res->_field8 = 0;
    }
    return res;
}

#pragma mark - AppDelegate

- (void)cb_applicationDidFinishLaunching:(id)arg {
    [self cb_applicationDidFinishLaunching:arg];
    if ([WeChatService(AccountService) canAutoAuth]) {
        [WeChatService(AccountService) AutoAuth];
    }
}

- (NSApplicationTerminateReply)cb_applicationShouldTerminate:(NSApplication *)sender {
    return NSTerminateNow;
}

@end

@implementation NSView (WeChatPlugin)

@end

@implementation NSViewController (WeChatPlugin)

#pragma mark - LeftViewController

- (void)cb_setViewControllers:(NSArray *)vcs {
    
    MMTimeLineMainViewController *timeLineMainVC = [[CBGetClass(MMTimeLineMainViewController) alloc] initWithNibName:@"MMContactsViewController" bundle:[NSBundle mainBundle]];
    [timeLineMainVC setTitle:[[NSBundle mainBundle] localizedStringForKey:@"Tabbar.Chats" value:@"" table:0x0]];
    
    
    MMTimeLineViewController *timeLineVC = [[CBGetClass(MMTimeLineViewController) alloc] initWithNibName:@"MMTimeLineViewController" bundle:[NSBundle pluginBundle]]; //[[CBGetClass(MMTimeLineViewController) alloc] initWithNibName:@"MMTimeLineViewController" bundle:[NSBundle pluginBundle]];
    timeLineMainVC.detailViewController = (id)timeLineVC;
    
    MMTabbarItem *tabBarItem = [[CBGetClass(MMTabbarItem) alloc] initWithTitle:@"朋友圈" onStateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected"] onStateAlternateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected-HI"] offStateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine"] offStateAlternateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-HI"]];
    [timeLineMainVC setTabbarItem:tabBarItem];
    
    NSMutableArray *viewControllers = [vcs mutableCopy];
    [viewControllers addObject:timeLineMainVC];
    [self cb_setViewControllers:[viewControllers copy]];

}

-(void)cb_mmDidLoad{
    NSLog(@"\n----\n ❤️ %@ didLoad \n----\n",NSStringFromClass([self class]));
}
-(void)cb_preViewDidLoad{

    [self cb_preViewDidLoad];
}

-(void)cb_preshow{
    [self cb_preshow];
}
@end

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"++++++++ WeChatPlugin loaded ++++++++");
    NSLog(@"++++++++ WeChatPlugin loaded ++++++++");
    [NSObject hookWeChat];
    [NSObject hookMMChatsTableCellView];
    
    CBRegisterClass(MMContactsViewController, MMTimeLineMainViewController);
    
    CBHookClassMethod(MMLogger, @selector(logWithMMLogLevel:module:file:line:func:message:), @selector(cb_logWithMMLogLevel:module:file:line:func:message:));
    
    CBHookInstanceMethod(MMCGIConfig, @selector(findItemWithFuncInternal:), @selector(cb_findItemWithFuncInternal:));
    
    CBHookInstanceMethod(AppDelegate, @selector(applicationDidFinishLaunching:), @selector(cb_applicationDidFinishLaunching:));
    CBHookInstanceMethod(AppDelegate, @selector(applicationShouldTerminate:), @selector(cb_applicationShouldTerminate:));
    
    CBHookInstanceMethod(LeftViewController, @selector(setViewControllers:), @selector(cb_setViewControllers:));
    
    
    CBHookInstanceMethod(MMViewController, @selector(viewDidLoad), @selector(cb_mmDidLoad));
    
    CBHookInstanceMethod(MMPreviewViewController, @selector(viewDidLoad), @selector(cb_preViewDidLoad));
    CBHookInstanceMethod(MMPreviewPanel, @selector(show), @selector(cb_preshow));
    
    
}
