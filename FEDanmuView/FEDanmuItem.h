//
//  FEDanmuItem.h
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弹幕数据模型
 */


/**
 *  弹幕行为类型枚举
 */
typedef NS_ENUM(NSUInteger, FEDanmuItemActionType) {
    /**
     *  正常的弹幕，从边界进来再从另一个对称边界出去
     */
    FEDanmuItemActionTypeNormal = 0,
    /**
     *  悬浮弹幕，会在幕布上悬浮一段时间
     */
    FEDanmuItemActionTypeSuspend = 1,
};

/**
 *  弹幕内容类型美剧
 */
typedef NS_ENUM(NSUInteger, FEDanmuItemContentType) {
    /**
     *  纯文本弹幕
     */
    FEDanmuItemContentTypeText = 0,
    /**
     *  使用UIView作为要显示内容的弹幕
     */
    FEDanmuItemContentTypeView = 1,
};


@interface FEDanmuItem : NSObject

/**
 *  弹幕的行为类型
 */
@property (nonatomic, assign, readonly) FEDanmuItemActionType actionType;

/**
 *  弹幕的内容类型
 */
@property (nonatomic, assign, readonly) FEDanmuItemContentType contentType;

/**
 *  需要被显示的View
 */
@property (nonatomic, strong, readonly) UIView *attachView;

/**
 *  弹幕的文字内容
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 *  背景图片
 */
@property (nonatomic, strong, readonly) UIImage *backgroundImage;

/**
 *  弹幕文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  弹幕文字字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  边框宽度，默认为0
 */
@property (nonatomic, assign) float borderWidth;

/**
 *  边框颜色，默认为nil
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  背景图片相对于Label的缩进
 */
@property (nonatomic, assign) UIEdgeInsets backgroundImageViewExpandInsets;

/**
 *  构造方法
 *
 *  @param text        文字内容
 *  @param actionType  弹幕的行为类型
 *  @param contentType 弹幕的内容类型
 *  @param attachView  用于显示的view
 */
+ (instancetype)itemWithText:(NSString *)text
             backgroundImage:(UIImage *)backgroundImage
                  actionType:(FEDanmuItemActionType)ationType
                 contentType:(FEDanmuItemContentType)contentType
                  attachView:(UIView *)attachView;

@end
