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
 *  弹幕留存的最长时间，也就是弹幕速度最慢时，默认10秒
 */
@property (nonatomic, assign) CGFloat maxDuration;

/**
 *  弹幕留存的最短时间，也就是弹幕速度最快时，默认5秒
 */
@property (nonatomic, assign) CGFloat minDuration;

/**
 *  刷新频率, 默认30帧
 */
@property (nonatomic, assign) NSUInteger fps;

/**
 *  每秒产生多少个弹幕， 默认为5
 */
@property (nonatomic, assign) NSUInteger persecoundDanmu;

/**
 *  弹幕轨道高度，会影响弹幕行数，默认为20
 */
@property (nonatomic, assign) CGFloat trackHeight;

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
 *  新增一个弹幕,会即时显示
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
