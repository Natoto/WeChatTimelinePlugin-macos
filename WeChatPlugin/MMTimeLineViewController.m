//
//  MMTimeLineViewController.m
//  WeChatPlugin
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMTimeLineViewController.h"
#import "MMTimeLineMgr.h"
#import "MMStatusCell.h"
#import "MMStatusImageMediaView.h"
#import "MMStatusLinkMediaView.h"

@interface MMTimeLineViewController () <NSTableViewDataSource, NSTableViewDelegate, MMStatusCellDelegate, MMTimeLineMgrDelegate>

@property (nonatomic, strong) MMTimeLineMgr *timeLineMgr;

@end

@implementation MMTimeLineViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeLineMgr = [MMTimeLineMgr new];
    _timeLineMgr.delegate = self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.wantsLayer = true;
    self.view.layer.backgroundColor = [NSColor colorWithRed:0.9843 green:0.9843 blue:0.9843 alpha:1.0].CGColor;
    
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MMStatusCell" bundle:[NSBundle pluginBundle]] forIdentifier:@"statusCell"];
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MMStatusImageMediaView" bundle:[NSBundle pluginBundle]] forIdentifier:@"statusImageMediaView"];
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MMStatusLinkMediaView" bundle:[NSBundle pluginBundle]] forIdentifier:@"statusLinkMediaView"];
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    NSScrollView *scrollView = [self.tableView enclosingScrollView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object:scrollView.contentView];
    
    NSButton * btn = [NSButton buttonWithTitle:@"导出json" target:self action:@selector(exportjson:)];
    [self.view addSubview:btn];
    btn.layer.backgroundColor = [NSColor blueColor].CGColor;
    btn.frame = NSMakeRect(self.view.bounds.size.width - 100, 20, 80, 50);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserTap:) name:@"tap_userprofile" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)handleUserTap:(NSNotification *)notify{
    NSString * userName = notify.object;
    self.timeLineMgr.userName = userName;
}


- (void)openAlertPanel:(NSString *)message{
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    //增加一个按钮
    [alert addButtonWithTitle:@"OK"];//1000
    
    //提示的标题
    [alert setMessageText:@"提示"];
    //提示的详细内容
    [alert setInformativeText:message];
    //设置告警风格
    [alert setAlertStyle:NSAlertStyleInformational];
    
    //开始显示告警
    [alert beginSheetModalForWindow:self.view.window
                  completionHandler:^(NSModalResponse returnCode){
                      //用户点击告警上面的按钮后的回调
                      NSLog(@"returnCode : %ld",returnCode);
                  }
     ];
}

-(IBAction)exportjson:(id)sender{
    
    NSPasteboard * board = [NSPasteboard generalPasteboard];
    NSString * json = [NSString stringWithFormat:@"[%@]",[self.timeLineMgr.jsonlist componentsJoinedByString:@","]];
//    [board setString:json forType:NSPasteboardTypeString];
//    [board writeFileContents:json];
    [board declareTypes:[NSArray arrayWithObject:NSStringPboardType]
               owner:self];
    [board setString:json forType:NSPasteboardTypeString];
    [self writetofile:json];
    [self openAlertPanel:@"朋友圈信息已导出到桌面，请查阅wechatTimeLine文件夹"];
//    [self openAlertPanel:@"朋友圈信息已复制到粘贴板,您可以去粘贴了"];
    
}

-(void)writetofile:(NSString *)string{
    
    NSFileManager *fm = [NSFileManager defaultManager];//创建NSFileManager实例
    //获得文件路径，第一个参数是要定位的路径 NSApplicationDirectory-获取应用程序路径，NSDocumentDirectory-获取文档路径
    //第二个参数是要定义的文件系统域
    NSArray *paths = [fm URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask];
    //沙盒路径
    NSURL *path = [paths objectAtIndex:0];
    //要查找的文件
    
    NSString *myFiledFolder = [path.relativePath stringByAppendingFormat:@"/wechatTimeLine"];
    
    NSString *myFiled;
    if (self.timeLineMgr.userName) {
        myFiled = [myFiledFolder stringByAppendingFormat:@"/%@-%.0f.json",self.timeLineMgr.userName,[NSDate timeIntervalSinceReferenceDate]];
    }else{
        myFiled = [myFiledFolder stringByAppendingFormat:@"/%.0f.json",[NSDate timeIntervalSinceReferenceDate]];
    }
    //判断文件是否存在
    BOOL result = [fm fileExistsAtPath:myFiled];
    //如果文件不存在
    if (!result) {
        NSString *content = string;
        //创建文件夹
        [fm createDirectoryAtPath:myFiledFolder withIntermediateDirectories:YES attributes:nil error:nil];
        //文件
        BOOL isCreate = [fm createFileAtPath:myFiled contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if (isCreate) {
            NSLog(@"创建成功");
            NSError * error;
//            [string writeToFile:myFiled atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if (error) {
                NSLog(@"save error:%@",error.description);
            }
        }
        else{
            NSLog(@"🌺 创建失败");
        }
    }
    
    NSLog(@"OUTPUT:%@",myFiled);
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self.timeLineMgr updateTimeLineHead];
}

-(void)setupGroupChatDetail:(id)sender{
    
    self.timeLineMgr.userName = nil;
    [self.timeLineMgr updateTimeLineHead];
}
//TODO: 点击了个人头像
-(void)setupContactDetail:(WCContactData*)sender{
    NSLog(@"%s",__func__);
    self.timeLineMgr.userName = sender.m_nsUsrName; 
    [self.timeLineMgr updateTimeLineHead];
}
#pragma mark -

- (void)scrollViewDidScroll:(NSNotification *)notification {
    NSScrollView *scrollView = notification.object;
    CGFloat currentPosition = CGRectGetMaxY([scrollView visibleRect]);
    CGFloat contentHeight = [self.tableView bounds].size.height - 5;
    
    if (currentPosition > contentHeight - 2.0) {
        [self onTableViewScrollToBottom];
    }
}

#pragma mark -

- (void)onTableViewScrollToBottom {
    [self.timeLineMgr updateTimeLineTail];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.timeLineMgr getTimeLineStatusCount];
}

#pragma mark - NSTableViewDelegate

- (nullable MMStatusMediaView *)tableView:(NSTableView *)tableView mediaViewForCell:(MMStatusCell *)cell status:(MMStatus *)status {
    
    MMStatusMediaView *mediaView;
    switch (status.mediaType) {
        case MMStatusMediaObjectTypeImage: {
            mediaView = [tableView makeViewWithIdentifier:@"statusImageMediaView" owner:cell];
        }
            break;
        case MMStatusMediaObjectTypeLink: {
            mediaView = [tableView makeViewWithIdentifier:@"statusLinkMediaView" owner:cell];
        }
            break;
        default:
            break;
    }
    return mediaView;
    
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    
    MMStatus *status = [self.timeLineMgr getTimeLineStatusAtIndex:row];
    MMStatusCell *cell = [tableView makeViewWithIdentifier:@"statusCell" owner:tableView];
    MMStatusMediaView *mediaView = [self tableView:tableView mediaViewForCell:cell status:status];
    [cell updateMediaView:mediaView];
    [cell updateViewWithStatus:status];
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    MMStatus *status = [self.timeLineMgr getTimeLineStatusAtIndex:row];
    return [MMStatusCell calculateHeightForStatus:status inTableView:tableView];
}

#pragma mark - MMStatusCellDelegate

- (void)cell:(MMStatusCell *)cell didClickMediaLink:(NSString *)url {
    
    [[CBGetClass(MMURLHandler) defaultHandler] handleURL:url];
    
}

#pragma mark - MMTimeLineMgrDelegate

- (void)onTimeLineStatusChange {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
