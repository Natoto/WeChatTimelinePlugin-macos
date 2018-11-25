//
//  MMStatusCell.h
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMStatusCellDelegate.h"

@class MMStatusMediaView;
@class MMStatus;

@interface MMStatusCell : NSTableCellView

@property (weak) IBOutlet NSImageView *profileImageView;
@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *tagTextField;
@property (weak) IBOutlet NSTextField *contentTextField;
@property (weak) IBOutlet MMStatusMediaView *mediaView;
@property (weak) MMStatusMediaView *mediaRealView;

@property (nonatomic, strong, readonly) MMStatus *status;
@property (nonatomic, weak) id<MMStatusCellDelegate> delegate;

@property (strong) IBOutlet NSLayoutConstraint *toTagTextFieldLayoutConstraint;
@property (strong) IBOutlet NSLayoutConstraint *toContentTextFieldLayoutConstraint;

- (void)updateMediaView:(MMStatusMediaView *)mediaView;
- (void)updateViewWithStatus:(MMStatus *)status;

+ (CGFloat)calculateHeightForStatus:(MMStatus *)status inTableView:(NSTableView *)tableView;

@end
