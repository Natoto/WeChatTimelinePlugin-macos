//
//  SnsTimeLineRequest.m
//  WeChatPlugin
//
//  Created by boob on 2018/4/11.
//  Copyright © 2018年 natoto. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SnsTimeLineRequest2.h"
#import <objc/runtime.h>

@implementation NSObject(SnsTimeLineRequest2)

+(void)load{
    
    /*
    const char * className = "SnsTimeLineRequest";
    Class kclass = objc_getClass(className);
    if (!kclass)
    {//NSClassFromString(@"PBGeneratedMessage");
        Class superClass = NSClassFromString(@"PBGeneratedMessage");//[NSObject class];
        kclass = objc_allocateClassPair(superClass, className, 0);
    }
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasBaseRequest"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasFirstPageMd5"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasMaxId"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasMinFilterId"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasLastRequestTime"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasClientLatestId"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"hasSession"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"lastRequestTime"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"baseRequest"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"firstPageMd5"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"maxId"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"minFilterId"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"clientLatestId"];
    [[self class] addSnsTimeLineRequestIvar:kclass ivar:"session"];
    
    
    class_addMethod(kclass, @selector(SetClientLatestId:), (IMP)setClientLatestId, "v@:@");
    class_addMethod(kclass, @selector(clientLatestId), (IMP)clientLatestId, "@@:");

    class_addMethod(kclass, @selector(SetSession:), (IMP)setSession, "v@:@");
    class_addMethod(kclass, @selector(session), (IMP)session, "@@:");
    
    
    class_addMethod(kclass, @selector(SetFirstPageMd5:), (IMP)setFirstPageMd5, "v@:@");
    class_addMethod(kclass, @selector(firstPageMd5), (IMP)firstPageMd5, "@@:");
    
    class_addMethod(kclass, @selector(SetLastRequestTime:), (IMP)setLastRequestTime, "v@:@");
    class_addMethod(kclass, @selector(lastRequestTime), (IMP)lastRequestTime, "@@:");
    
    class_addMethod(kclass, @selector(SetBaseRequest:), (IMP)setBaseRequest, "v@:@");
    class_addMethod(kclass, @selector(baseRequest), (IMP)baseRequest, "@@:");
    
    
    class_addMethod(kclass, @selector(SetMaxId:), (IMP)setMaxId, "v@:@");
    class_addMethod(kclass, @selector(maxId), (IMP)maxId, "@@:");
    
    
    class_addMethod(kclass, @selector(SetMinFilterId:), (IMP)setMinFilterId, "v@:@");
    class_addMethod(kclass, @selector(minFilterId), (IMP)minFilterId, "@@:");
    
    
    objc_registerClassPair(kclass);
    */
}
char * kSession;
char * kbaseRequest;
char * kClientLatestId;
char * kminFilterId;
#pragma mark - minFilterId
static void setMinFilterId(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "minFilterId");
    object_setIvar(target, ivar, value);
    objc_setAssociatedObject(target, kminFilterId, value, OBJC_ASSOCIATION_RETAIN);
    NSLog(@"call setminFilterId");
}
static id minFilterId(id target, SEL cmd)
{
    NSLog(@"call minFilterId");
    Ivar ivar = class_getInstanceVariable([target class], "minFilterId");
    return object_getIvar(target, ivar);
//    id obj = objc_getAssociatedObject(target, kbaseRequest);
    //    return obj;
}


#pragma mark - maxId

static void setMaxId(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "maxId");
    object_setIvar(target, ivar, value);
//    objc_setAssociatedObject(target, kbaseRequest, value, OBJC_ASSOCIATION_RETAIN);
    NSLog(@"call set maxId");
}
static id maxId(id target, SEL cmd)
{
   NSLog(@"call maxId");
   Ivar ivar = class_getInstanceVariable([target class], "maxId");
   return object_getIvar(target, ivar);
//    id obj = objc_getAssociatedObject(target, kbaseRequest);
//    return obj;
}


#pragma mark - baseRequest
static void setBaseRequest(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "baseRequest");
    object_setIvar(target, ivar, value);
    objc_setAssociatedObject(target, kbaseRequest, value, OBJC_ASSOCIATION_RETAIN);
    NSLog(@"call baseRequest");
}
static id baseRequest(id target, SEL cmd)
{
    NSLog(@"call baseRequest");
//    Ivar ivar = class_getInstanceVariable([target class], "baseRequest");
//    return object_getIvar(target, ivar);
    id obj = objc_getAssociatedObject(target, kbaseRequest);
    return obj;
}


#pragma mark - lastRequestTime
static void setLastRequestTime(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "lastRequestTime");
    object_setIvar(target, ivar, value);
    NSLog(@"call set firstPageMd5");
}
static id lastRequestTime(id target, SEL cmd)
{
    NSLog(@"call lastRequestTime");
    Ivar ivar = class_getInstanceVariable([target class], "lastRequestTime");
    return object_getIvar(target, ivar);
}


#pragma mark - firstPageMd5
static void setFirstPageMd5(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "firstPageMd5");
    object_setIvar(target, ivar, value);
    NSLog(@"call firstPageMd5");
}
static id firstPageMd5(id target, SEL cmd)
{
    NSLog(@"call firstPageMd5");
    Ivar ivar = class_getInstanceVariable([target class], "firstPageMd5");
    return object_getIvar(target, ivar);
}

#pragma mark - clientlastid
static void setClientLatestId(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "clientLatestId");
    object_setIvar(target, ivar, value);
    NSLog(@"call setClientLatestId");
}
static id clientLatestId(id target, SEL cmd)
{
    NSLog(@"call clientLatestId");
   Ivar ivar = class_getInstanceVariable([target class], "clientLatestId");
   return object_getIvar(target, ivar);
   
}

#pragma mark - session

static void setSession(id target, SEL cmd, id value)
{
    Ivar ivar = class_getInstanceVariable([target class], "session");
    object_setIvar(target, ivar, value);
    objc_setAssociatedObject(target, &kSession, value, OBJC_ASSOCIATION_RETAIN);
    NSLog(@"call setExpressionFormula");
}
static id session(id target, SEL cmd)
{
    NSLog(@"call getExpressionFormula");
    return objc_getAssociatedObject(target, &kSession);
}


+(void)addSnsTimeLineRequestIvar:(Class)kclass ivar:(const char *)ivarstr{
    NSUInteger size;
    NSUInteger alignment;
    NSGetSizeAndAlignment("*", &size, &alignment);
    class_addIvar(kclass, ivarstr, size, alignment, "*");
}

@end
 

