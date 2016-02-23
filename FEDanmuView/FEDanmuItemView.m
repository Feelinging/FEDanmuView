//
//  FEDanmuItemView.m
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import "FEDanmuItemView.h"
#import "FEDanmuItem.h"

@interface FEDanmuItemView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FEDanmuItemView

+ (instancetype)itemViewWithItem:(FEDanmuItem *)item {
    return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(FEDanmuItem *)item {
    if (self = [super init]) {
        [self baseInit];
        
        _item = item;
        
        [self configWithItem:item];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    // 不可交互
    self.userInteractionEnabled = NO;
    
    // 背景图
    _backgroundImageView = [[UIImageView alloc] init];
    
    [self addSubview:_backgroundImageView];
    
    // 文本Label
    _textLabel = [[UILabel alloc] init];
    
    [self addSubview:_textLabel];
}

#pragma mark public method

- (void)prepareForReuse {
    [_item.attachView removeFromSuperview];
    
    _item = nil;
    
    self.speed = 0;
    
    [self removeFromSuperview];
}

- (void)reuseWithItem:(FEDanmuItem *)item {
    _item = item;
    
    [self configWithItem:item];
}

#pragma mark private method

- (FEDanmuItemView *)configWithItem:(FEDanmuItem *)item {
    self.textLabel.hidden = NO;
    self.textLabel.font = [UIFont systemFontOfSize:16.f];
    self.textLabel.textColor = [UIColor blackColor];
    
    self.backgroundImageView.hidden = NO;
    
    self.layer.borderWidth = item.borderWidth;
    self.layer.borderColor = item.borderColor.CGColor;
    
    switch (item.contentType) {
        case FEDanmuItemContentTypeText:
            // set text
            self.textLabel.text = item.text;
            if (item.font) {
                self.textLabel.font = item.font;
            }
            
            if (item.textColor) {
                self.textLabel.textColor = item.textColor;
            }
            
            // change frame
            [self.textLabel sizeToFit];
            
            self.backgroundImageView.frame = CGRectMake(0, 0, self.textLabel.bounds.size.width + item.backgroundImageViewExpandInsets.left + item.backgroundImageViewExpandInsets.right, self.textLabel.bounds.size.height + item.backgroundImageViewExpandInsets.top + item.backgroundImageViewExpandInsets.bottom);
            
            self.backgroundImageView.image = item.backgroundImage;
            
            self.textLabel.frame = CGRectMake(item.backgroundImageViewExpandInsets.left, item.backgroundImageViewExpandInsets.top, self.textLabel.bounds.size.width, self.textLabel.bounds.size.height);
            
            self.bounds = self.backgroundImageView.bounds;
            
            
            break;
        case FEDanmuItemContentTypeView:
            // hide textLabel and backgroundView
            self.textLabel.hidden = YES;
            self.backgroundImageView.hidden = YES;
            
            // change frame
            self.bounds = item.attachView.bounds;
            [self addSubview:item.attachView];
            
            item.attachView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            break;
        default:
            break;
    }
    
    return self;
}

- (void)updatePositionWithFps:(NSUInteger)fps {
    if (self.item.actionType == FEDanmuItemActionTypeNormal) {
        CGRect frame = self.frame;
        frame.origin.x -= self.speed / fps;
        self.frame = frame;
    }
}

@end
