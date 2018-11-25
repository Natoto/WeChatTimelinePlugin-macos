//
//  MMStatusCellDelegate.h
//  WeChatPlugin
//
//  Created by nato on 2017/3/25.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMStatusCell;

@protocol MMStatusCellDelegate <NSObject>

@optional
- (void)cell:(MMStatusCell *)cell didClickMediaLink:(NSString *)url;

@end
