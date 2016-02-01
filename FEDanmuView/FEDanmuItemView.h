//
//  FEDanmuItemView.h
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  承载单个弹幕的视图
 */

@class FEDanmuItem;

@interface FEDanmuItemView : UIView

/**
 *  弹幕数据模型属性
 */
@property (nonatomic, strong, readonly) FEDanmuItem *item;

/**
 *  移动速度
 */
@property (nonatomic, assign) CGFloat speed;

/**
 *  构造方法
 *
 *  @param item 弹幕模型
 */
+ (instancetype)itemViewWithItem:(FEDanmuItem *)item;

/**
 *  准备重用
 */
- (void)prepareForReuse;

/**
 *  重用时调用
 *
 *  @param item 新的模型数据
 */
- (void)reuseWithItem:(FEDanmuItem *)item;

/**
 *  更新位置
 */
- (void)updatePosition;

@end
