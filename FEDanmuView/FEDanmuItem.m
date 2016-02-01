//
//  FEDanmuItem.m
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import "FEDanmuItem.h"

@implementation FEDanmuItem

#pragma mark initialize
+ (instancetype)itemWithText:(NSString *)text
                  actionType:(FEDanmuItemActionType)actionType
                 contentType:(FEDanmuItemContentType)contentType
                  attachView:(UIView *)attachView{
    return [[self alloc] initWithText:text actionType:actionType contentType:contentType attachView:attachView];
}

- (instancetype)initWithText:(NSString *)text
                  actionType:(FEDanmuItemActionType)actionType
                 contentType:(FEDanmuItemContentType)contentType
                  attachView:(UIView *)attachView {
    if (self = [super init]) {
        _text = text.copy;
        _actionType = actionType;
        _contentType = contentType;
        _attachView = attachView;
        
        // 根据时间生成itemId
        NSDate *now = [NSDate date];
        _itemId = @([now timeIntervalSince1970]).stringValue;
    }
    return self;
}

- (BOOL)isEqual:(FEDanmuItem *)object {
    if (self == object) {
        return YES;
    }
    
    if ([self.itemId isEqualToString:object.itemId]) {
        return YES;
    }
    
    return NO;
}

@end
