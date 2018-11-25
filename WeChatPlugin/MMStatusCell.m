//
//  MMStatusCell.m
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMStatusCell.h"
#import "MMStatusMediaView.h"
#import "MMStatusImageMediaView.h"
#import "MMStatusLinkMediaView.h"
#import "MMStatus.h"
#import "MMStatusMediaObject.h"
#import "MMStatusImageMediaObject.h"
#import "MMStatusLinkMediaObject.h"

@implementation MMStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.wantsLayer = true;
    self.profileImageView.layer.borderWidth = 0.5;
    self.profileImageView.layer.borderColor = [NSColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.layer.masksToBounds = true;
}

- (void)updateMediaView:(MMStatusMediaView *)mediaView {
    [self.mediaRealView removeFromSuperview];
    self.mediaRealView = nil;
    self.mediaRealView = mediaView;
    [self addSubview:mediaView];
    self.mediaRealView.translatesAutoresizingMaskIntoConstraints = false;
    if (self.mediaRealView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    }
}

- (void)updateViewWithStatus:(MMStatus *)status {
    if (_status == status) {
        return;
    }
    _status = status;
    [_status valiateData];
    self.profileImageView.image = [WeChatService(MMAvatarService) defaultAvatarImage];
    MMAvatarService *service = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMAvatarService)];
    [service getAvatarImageWithUrl:status.profileImageURLString completion:^(NSImage *image) {
        self.profileImageView.image = image;
    }];
    self.nameTextField.stringValue = status.nameString?status.nameString:@"";
    self.tagTextField.stringValue = [NSString stringWithFormat:@"%@%@", status.timeString, [status hasSource] ? [NSString stringWithFormat:@" - %@", status.sourceString] : @""];
    self.toContentTextFieldLayoutConstraint.active = [status hasContent];
    self.toTagTextFieldLayoutConstraint.active = ![status hasContent];
    self.contentTextField.attributedStringValue = status.contentAttributedString;
    
    if ([status hasMediaObject]) {
        switch (status.mediaType) {
            case MMStatusMediaObjectTypeImage: {
                MMStatusImageMediaObject *mediaObject = (MMStatusImageMediaObject *)status.mediaObject;
                MMStatusImageMediaView *mediaView = (MMStatusImageMediaView *)self.mediaRealView;
                for (NSImageView *imageView in mediaView.imageViews) {
                    imageView.hidden = true;
                }
                for (NSInteger i = 0; i < mediaObject.imageURLStrings.count; i ++) {
                    NSString *imageURLString = mediaObject.imageURLStrings[i];
                    NSImageView *imageView = mediaView.imageViews[i];
                    imageView.hidden = false;
                    imageView.image = nil;
                    MMAvatarService *service = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMAvatarService)];
                    [service getAvatarImageWithUrl:imageURLString completion:^(NSImage *image) {
                        imageView.image = image;
                    }];
                }
            }
                break;
            case MMStatusMediaObjectTypeLink: {
                MMStatusLinkMediaObject *mediaObject = (MMStatusLinkMediaObject *)status.mediaObject;
                MMStatusLinkMediaView *mediaView = (MMStatusLinkMediaView *)self.mediaRealView;
                mediaView.iconImageView.image = nil;
                MMAvatarService *service = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMAvatarService)];
                [service getAvatarImageWithUrl:mediaObject.imageURLString completion:^(NSImage *image) {
                    mediaView.iconImageView.image = image;
                }];
                mediaView.titleTextField.stringValue = mediaObject.title;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Event

- (void)mouseUp:(NSEvent *)event {
    CGPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if ([self.status hasMediaObject]) {
        switch (self.status.mediaType) {
            case MMStatusMediaObjectTypeLink: {
                BOOL isClickLinkView = [self mouse:point inRect:self.mediaRealView.frame];
                if (isClickLinkView) {
                    if ([self.delegate respondsToSelector:@selector(cell:didClickMediaLink:)]) {
                        [self.delegate cell:self didClickMediaLink:[(MMStatusLinkMediaObject *)self.status.mediaObject linkURLString]];
                    }
                }
                break;
            }
            case MMStatusMediaObjectTypeImage:{
                
                __block NSInteger selectindex = -1;
                [self.mediaRealView.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BOOL isClickLinkView = [self mouse:point inRect:obj.frame];
                    if (isClickLinkView) {
                        selectindex = idx;
                    }
                }];
//                BOOL isClickLinkView = [self mouse:point inRect:self.mediaRealView.frame];
                if (selectindex >= 0) {
                    MMStatusImageMediaObject * media = (MMStatusImageMediaObject *)self.status.mediaObject;
                    NSArray * images =  media.imageURLStrings;
                    if (images.count > selectindex && [self.delegate respondsToSelector:@selector(cell:didClickMediaLink:)]) {
                        [self.delegate cell:self didClickMediaLink:images[selectindex]];
                    }
                }

                break;
            }
            default:
                break;
        }
    }
}

- (void)mouseDown:(NSEvent *)event {
    
}

#pragma mark - Height

+ (CGFloat)calculateHeightForStatus:(MMStatus *)status inTableView:(NSTableView *)tableView {
    CGFloat height = 55;
    if ([status hasContent]) {
        height += 5;
        NSRect rect = [status.contentAttributedString boundingRectWithSize:NSMakeSize(tableView.frame.size.width - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        height += rect.size.height; 
    }
    if ([status hasMediaObject]) {
        switch (status.mediaType) {
            case MMStatusMediaObjectTypeImage: {
                CGFloat imageSize = (tableView.frame.size.width - 80) / 3.0;
                MMStatusImageMediaObject *mediaObject = (MMStatusImageMediaObject *)status.mediaObject;
                NSInteger rowCount = (mediaObject.imageURLStrings.count - 1) / 3 + 1;
                height += (NSInteger)(rowCount * imageSize);
            }
                break;
            case MMStatusMediaObjectTypeLink:
                height += 40;
            default:
                break;
        }
    }
    height += 10;
    return height;
}

@end
