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
             backgroundImage:(UIImage *)backgroundImage
                  actionType:(FEDanmuItemActionType)actionType
                 contentType:(FEDanmuItemContentType)contentType
                  attachView:(UIView *)attachView{
    return [[self alloc] initWithText:text backgroundImage:backgroundImage actionType:actionType contentType:contentType attachView:attachView];
}

- (instancetype)initWithText:(NSString *)text
             backgroundImage:(UIImage *)backgroundImage
                  actionType:(FEDanmuItemActionType)actionType
                 contentType:(FEDanmuItemContentType)contentType
                  attachView:(UIView *)attachView {
    if (self = [super init]) {
        _text = text.copy;
        _backgroundImage = backgroundImage;
        _actionType = actionType;
        _contentType = contentType;
        _attachView = attachView;
    }
    return self;
}

@end
