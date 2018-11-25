//
//  MMTimeLineMgr.m
//  WeChatPlugin
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMTimeLineMgr.h"
#import "NSObject+ObjectMap.h"
#import "SnsTimeLineRequest2.h"
@interface MMTimeLineMgr () <MMCGIDelegate>

@property (nonatomic, assign, getter=isRequesting) BOOL requesting;
@property (nonatomic, strong) NSString *firstPageMd5;
@property (nonatomic, strong) SKBuiltinBuffer_t *session;
@property (nonatomic, strong) NSMutableArray *statuses;

@end

@implementation MMTimeLineMgr

#pragma mark - Network

- (void)updateTimeLineHead {
    [self requestTimeLineDataAfterItemID:0];
}

- (void)updateTimeLineTail {
    MMStatus *status = [self.statuses lastObject];
    [self requestTimeLineDataAfterItemID:status.statusId];
}

- (void)requestUserPageTimeLineDataAfterItemID:(unsigned long long)itemID username:(NSString *)username{
    if (self.isRequesting) {
        return;
    }
    self.requesting = true;
    SnsUserPageRequest *request = [[CBGetClass(SnsUserPageRequest) alloc] init];
    request.username = username;
    request.baseRequest = [CBGetClass(MMCGIRequestUtil) InitBaseRequestWithScene:0];
//    request.clientLatestId = 0;
    request.firstPageMd5 = itemID == 0 ? self.firstPageMd5 : @"";
    request.lastRequestTime = 0;
    request.maxId = itemID;
    request.minFilterId = 0;
//    request.session = self.session;
    MMCGIWrap *cgiWrap = [[CBGetClass(MMCGIWrap) alloc] init];
    cgiWrap.m_requestPb = request;
    cgiWrap.m_functionId = kMMCGIWrapHomePageFunctionId;
    
    MMCGIService *cgiService = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMCGIService)];
    [cgiService RequestCGI:cgiWrap delegate:self];
    
}

- (void)requestTimeLineDataAfterItemID:(unsigned long long)itemID {
    if (self.isRequesting) {
        return;
    }
    if (self.userName) {//去拉取个人主页
        [self requestUserPageTimeLineDataAfterItemID:itemID username:self.userName];
        return;
    }
    self.requesting = true;
    SnsTimeLineRequest *request = [[CBGetClass(SnsTimeLineRequest) alloc] init];
    request.baseRequest = [CBGetClass(MMCGIRequestUtil) InitBaseRequestWithScene:0];
    request.clientLatestId = 0;
    request.firstPageMd5 = itemID == 0 ? self.firstPageMd5 : @"";
    request.lastRequestTime = 0;
    request.maxId = itemID;
    request.minFilterId = 0;
    request.session = self.session;
    MMCGIWrap *cgiWrap = [[CBGetClass(MMCGIWrap) alloc] init];
    cgiWrap.m_requestPb = request;
    cgiWrap.m_functionId = kMMCGIWrapTimeLineFunctionId;
    
    MMCGIService *cgiService = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMCGIService)];
    [cgiService RequestCGI:cgiWrap delegate:self];
    
}

- (NSMutableArray *)jsonlist {
    if (!_jsonlist) {
        _jsonlist = [[NSMutableArray alloc] init];
    }
    return _jsonlist;
}
#pragma mark - MMCGIDelegate
 -(void)OnResponseCGIFailedWithSessionId:(unsigned int)arg1 cgiWrap:(MMCGIWrap *)cgiWra errType:(int)arg2 errCode:(int)errcode
{
    NSLog(@"错误： %s",__func__);
    
}

- (void)TimeLineOnResponseCGI:(BOOL)arg1 sessionId:(unsigned int)arg2 cgiWrap:(MMCGIWrap *)cgiWrap {
    NSLog(@"%d %d %@", arg1, arg2, cgiWrap);
    SnsTimeLineRequest *request = (SnsTimeLineRequest *)cgiWrap.m_requestPb;
    SnsTimeLineResponse *response = (SnsTimeLineResponse *)cgiWrap.m_responsePb;
    
    self.session = response.session;
    NSMutableArray *statuses = [NSMutableArray new];
    NSString * jsonstr = @"";
    for (SnsObject *snsObject in response.objectList) {
        MMStatus *status = [MMStatus new];
        [status updateWithSnsObject:snsObject];
        [statuses addObject:status];
        
        MMStatusSimple *st = [MMStatusSimple new];
        [st updateWithSnsObject:snsObject];
        NSString * stajson = [st JSONString];
        jsonstr = [jsonstr stringByAppendingFormat:@"%@,",stajson];
    }
    jsonstr = [jsonstr stringByAppendingFormat:@""];
    NSLog(@"\n\njson:\n%@\n\n",jsonstr);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isRefresh = request.maxId == 0;
        if (isRefresh) {
            self.firstPageMd5 = response.firstPageMd5;
            if (statuses.count) {
                self.statuses = statuses;
            }else{
                [self.statuses removeAllObjects];
            }
            self.jsonlist = [@[jsonstr] mutableCopy];
        }
        else {
            [self.statuses addObjectsFromArray:statuses];
            [self.jsonlist addObject:jsonstr];
        }
        self.requesting = false;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTimeLineStatusChange)]) {
            [self.delegate onTimeLineStatusChange];
        }
    });
}


- (void)UserPageOnResponseCGI:(BOOL)arg1 sessionId:(unsigned int)arg2 cgiWrap:(MMCGIWrap *)cgiWrap {
    NSLog(@"%d %d %@", arg1, arg2, cgiWrap);
    SnsUserPageRequest *request = (SnsUserPageRequest *)cgiWrap.m_requestPb;
    SnsTimeLineResponse *response = (SnsTimeLineResponse *)cgiWrap.m_responsePb;
//    self.session = response.session;
    NSMutableArray *statuses = [NSMutableArray new];
    NSString * jsonstr = @"";
    for (SnsObject *snsObject in response.mutableObjectListList) {
        MMStatus *status = [MMStatus new];
        [status updateWithSnsObject:snsObject];
        [statuses addObject:status];
        
        MMStatusSimple *st = [MMStatusSimple new];
        [st updateWithSnsObject:snsObject];
        NSString * stajson = [st JSONString];
        jsonstr = [jsonstr stringByAppendingFormat:@"%@,",stajson];
    }
    jsonstr = [jsonstr stringByAppendingFormat:@""];
    NSLog(@"\n\njson:\n%@\n\n",jsonstr);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isRefresh = request.maxId == 0;
        if (isRefresh) {
            self.firstPageMd5 = response.firstPageMd5;
            if (statuses.count) {
                self.statuses = statuses;
            }else{
                [self.statuses removeAllObjects];
            }
            self.jsonlist = [@[jsonstr] mutableCopy];
        }
        else {
            [self.statuses addObjectsFromArray:statuses];
            [self.jsonlist addObject:jsonstr];
        }
        self.requesting = false;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTimeLineStatusChange)]) {
            [self.delegate onTimeLineStatusChange];
        }
    });
}


- (void)OnResponseCGI:(BOOL)arg1 sessionId:(unsigned int)arg2 cgiWrap:(MMCGIWrap *)cgiWrap {
   
    SnsTimeLineRequest *request = (SnsTimeLineRequest *)cgiWrap.m_requestPb;
    SnsTimeLineResponse *response = (SnsTimeLineResponse *)cgiWrap.m_responsePb;
 
    if ([NSStringFromClass([response class]) isEqualToString:@"SnsTimeLineResponse"]) {
        [self TimeLineOnResponseCGI:arg1 sessionId:arg2 cgiWrap:cgiWrap];
    }
    else if ([NSStringFromClass([response class]) isEqualToString:@"SnsUserPageResponse"]) {
        [self UserPageOnResponseCGI:arg1 sessionId:arg2 cgiWrap:cgiWrap];
    }
}

#pragma mark - 

- (NSUInteger)getTimeLineStatusCount {
    return [self.statuses count];
}

- (MMStatus *)getTimeLineStatusAtIndex:(NSUInteger)index {
    if (index >= self.statuses.count) {
        return nil;
    }
    else {
        return self.statuses[index];
    }
}

@end
