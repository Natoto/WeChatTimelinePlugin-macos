//
//  TKHelper.h
//  WeChatPlugin
//
//  Created by nato on 2017/1/11.
//  Copyright © 2017年 github:natototo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TKHelper : NSObject

/**
 替换对象方法

 @param originalClass 原始类
 @param originalSelector 原始类的方法
 @param swizzledClass 替换类
 @param swizzledSelector 替换类的方法
 */
void tk_hookMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

/**
 替换类方法
 
 @param originalClass 原始类
 @param originalSelector 原始类的类方法
 @param swizzledClass 替换类
 @param swizzledSelector 替换类的类方法
 */
void tk_hookClassMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

@end
