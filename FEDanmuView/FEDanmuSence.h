//
//  FEDanmuSence.h
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用于承载弹幕的幕布视图
 */

/**
 *  弹幕幕布状态
 */
typedef NS_ENUM(NSUInteger, FEDanmuSenceState) {
    /**
     *  没有开始
     */
    FEDanmuSenceStateNone = 0,
    /**
     *  正在播放弹幕
     */
    FEDanmuSenceStatePlaying = 1,
    /**
     *  暂停
     */
    FEDanmuSenceStatePause = 2,
    /**
     *  播放完了
     */
    FEDanmuSenceStateDown = 3,
};

@class FEDanmuItem;

@interface FEDanmuSence : UIView

/**
 *  当前弹幕幕布的状态
 */
@property (nonatomic, assign, readonly) FEDanmuSenceState state;

/**
 *  是否循环播放，默认为NO
 */
@property (nonatomic, assign) BOOL repeatPlay;

/**
 *  构造方法
 *
 *  @param items 弹幕模型数组
 */
+ (instancetype)senceWithItems:(NSArray<FEDanmuItem *> *)items;

/**
 *  重新设置items
 */
- (void)resetWithItems:(NSArray<FEDanmuItem *> *)items;

/**
 *  新增一个弹幕
 */
- (void)insertItem:(FEDanmuItem *)item;

/**
 *  开始播放弹幕，如果当前状态是被暂停则会继续播放
 */
- (void)start;

/**
 *  重置
 */
- (void)reset;

/**
 *  重新开始，相当于重置之后再调用了开始
 */
- (void)restart;

/**
 *  暂停
 */
- (void)pause;

@end
