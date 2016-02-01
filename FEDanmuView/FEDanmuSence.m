//
//  FEDanmuSence.m
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import "FEDanmuSence.h"
#import "FEDanmuItem.h"
#import "FEDanmuItemView.h"

#define kMinSpeed self.bounds.size.width / 8.f
#define kDefaultSpeed self.bounds.size.width / 5.f
#define kSpeedLimit self.bounds.size.width / 3.f

@interface FEDanmuSence ()

/**
 * 源数据源
 */
@property (nonatomic, strong) NSMutableArray<FEDanmuItem *> *modelArray;

/**
 * 用于做显示的数据源
 */
@property (nonatomic, strong) NSMutableArray<FEDanmuItem *> *watingForDisplayModelArray;

/**
 * 正在使用的弹幕视图
 */
@property (nonatomic, strong) NSMutableArray<FEDanmuItemView *> *usingViews;

/**
 *  准备重用的弹幕视图
 */
@property (nonatomic, strong) NSMutableArray<FEDanmuItemView *> *reuseViews;

/**
 *  更新位置的计时器
 */
@property (nonatomic, strong) CADisplayLink *updatePositionTimer;

/**
 *  插入弹幕视图的timer
 */
@property (nonatomic, strong) NSTimer *insertDanmuItemViewTimer;

/**
 *  轨道数
 */
@property (nonatomic, assign) NSUInteger trackLimit;

/**
 *  轨道数对应的弹幕视图数组 @[@[view1,view2]]
 */
@property (nonatomic, strong) NSMutableArray *trackViewArray;

@end

@implementation FEDanmuSence

#pragma mark initialize
+ (instancetype)senceWithItems:(NSArray<FEDanmuItem *> *)items {
    return [[self alloc] initWithDanmuItems:items];
}

- (instancetype)initWithDanmuItems:(NSArray<FEDanmuItem *> *)items {
    if (self = [super init]) {
        
        [self baseInit];
        
        [_modelArray addObjectsFromArray:items];
        [_watingForDisplayModelArray addObjectsFromArray:items];
    }
    return self;
}

- (void)baseInit {
    // clipsToBounds
    self.clipsToBounds = YES;
    
    // init arrays
    _modelArray = [NSMutableArray array];
    
    _watingForDisplayModelArray = [NSMutableArray array];
    
    _usingViews = [NSMutableArray array];
    
    _reuseViews = [NSMutableArray array];
    
    _persecoundDanmu = 5;
    
    _trackHeight = 20;
    
    [self addObserve];
}

- (void)dealloc {
    [_insertDanmuItemViewTimer invalidate];
    _insertDanmuItemViewTimer = nil;
    
    [_updatePositionTimer invalidate];
    _updatePositionTimer = nil;
    
    _modelArray = nil;
    _watingForDisplayModelArray = nil;
    
    _usingViews = nil;
    _reuseViews = nil;
    
    [self removeObserve];
}

#pragma mark public method
- (void)resetWithItems:(NSArray<FEDanmuItem *> *)items {    
    self.modelArray = items.mutableCopy;
    [self reset];
}

- (void)insertItem:(FEDanmuItem *)item {
    
    [self.watingForDisplayModelArray insertObject:item atIndex:0];
    
    [self.modelArray addObject:item];
}

- (void)start {
    if (self.state == FEDanmuSenceStatePlaying) return;
    
    if (self.watingForDisplayModelArray.count == 0 && self.modelArray.count > 0 && self.state != FEDanmuSenceStatePause) {
        [self reset];
    }
    
    [self startInsertDanmuTimer];
    
    [self startUpdatePositionTimer];
    
    _state = FEDanmuSenceStatePlaying;
}

- (void)reset {
    self.watingForDisplayModelArray = self.modelArray.mutableCopy;
    
    [self.trackViewArray removeAllObjects];
    
    [self resetInsertDanmuTimer];
    
    [self resetUpdatePositonTimer];
    
    for (FEDanmuItemView *subview in self.subviews) {
        [self danmuViewReachedLimitBounds:subview];
    }
    
    _state = FEDanmuSenceStateNone;
}

- (void)pause {
    if (self.state == FEDanmuSenceStatePause) return;
    
    [self resetUpdatePositonTimer];
    
    [self resetInsertDanmuTimer];
    
    _state = FEDanmuSenceStatePause;
}

- (void)restart {
    [self reset];
    
    [self startUpdatePositionTimer];
    
    [self startInsertDanmuTimer];
    
    _state = FEDanmuSenceStatePlaying;
}

#pragma mark getter&setter
- (CADisplayLink *)updatePositionTimer {
    if (!_updatePositionTimer) {
        _updatePositionTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePositions)];
    }
    return _updatePositionTimer;
}

- (NSTimer *)insertDanmuItemViewTimer {
    if (!_insertDanmuItemViewTimer) {
        _insertDanmuItemViewTimer = [NSTimer timerWithTimeInterval:1.0 / self.persecoundDanmu target:self selector:@selector(addNewDanmuToSence) userInfo:nil repeats:YES];
    }
    return _insertDanmuItemViewTimer;
}

- (void)setPersecoundDanmu:(NSUInteger)persecoundDanmu {
    if (_persecoundDanmu != persecoundDanmu) {
        _persecoundDanmu = persecoundDanmu;
        
        // 
        [self resetInsertDanmuTimer];
        
        if (self.state == FEDanmuSenceStatePlaying) {
            [self startInsertDanmuTimer];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // 每个轨道20的高度
    self.trackLimit = floorf((frame.size.height / self.trackHeight));
    
    // 轨道和轨道上的弹幕视图map
    self.trackViewArray = [NSMutableArray array];
}

- (void)setTrackHeight:(CGFloat)trackHeight {
    if (_trackHeight != trackHeight) {
        _trackHeight = trackHeight;
        
        [self.trackViewArray removeAllObjects];
        self.trackLimit = floorf(self.bounds.size.height / _trackHeight);
        
        switch (self.state) {
            case FEDanmuSenceStateNone:
            case FEDanmuSenceStatePause:
            case FEDanmuSenceStateDown:
                [self reset];
                break;
            case FEDanmuSenceStatePlaying:
                [self restart];
                break;
            default:
                break;
        }
    }
}

#pragma mark private method
// 重置更新位置的timer
- (void)resetUpdatePositonTimer {
    [_updatePositionTimer invalidate];
    _updatePositionTimer = nil;
}

// 重置插入弹幕的timer
- (void)resetInsertDanmuTimer {
    [_insertDanmuItemViewTimer invalidate];
    _insertDanmuItemViewTimer = nil;
}

// 启动更新位置的timer
- (void)startUpdatePositionTimer {
    [self.updatePositionTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// 启动插入弹幕的timer
- (void)startInsertDanmuTimer {
    [[NSRunLoop mainRunLoop] addTimer:self.insertDanmuItemViewTimer forMode:NSDefaultRunLoopMode];
    
    [self.insertDanmuItemViewTimer fire];
}

// 获取可用的弹幕视图
- (FEDanmuItemView *)dequeReusableViewWithItem:(FEDanmuItem *)item {
    FEDanmuItemView *view;
    
    if (self.reuseViews.count > 0) {
        // 从重用视图数组里面获取
        view = self.reuseViews.firstObject;
        
        // 从重用视图数组里面移除
        [self.reuseViews removeObject:view];
    }
    else {
        // 新生成一个
        view = [[FEDanmuItemView alloc] init];
    }
    
    // 通过item设置view
    [view reuseWithItem:item];
    
    // 插入正在使用的视图数组
    [self.usingViews addObject:view];
    
    return view;
}

- (FEDanmuSence *)danmuViewReachedLimitBounds:(FEDanmuItemView *)view {
    // 移除
    [self.usingViews removeObject:view];
    
    // 从轨道数组移除
    [[self trackViewArrayAtTrak:view.track] removeObject:view];
    
    // 准备重用
    [view prepareForReuse];
    
    [self.reuseViews addObject:view];
    
    return self;
}

- (FEDanmuSence *)updatePositions {
    NSArray *tmp = self.usingViews.copy;
    for (FEDanmuItemView *view in tmp) {
        [view updatePosition];
        
        if (CGRectGetMaxX(view.frame) < 0) {
            [self danmuViewReachedLimitBounds:view];
        }
    }
    return self;
}

- (FEDanmuSence *)addNewDanmuToSence {
    if (self.watingForDisplayModelArray.count == 0){
        if (self.repeatPlay) {
            self.watingForDisplayModelArray = self.modelArray.mutableCopy;
            [_insertDanmuItemViewTimer invalidate];
            _insertDanmuItemViewTimer = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self restart];
            });
        }
        else {
            _state = FEDanmuSenceStateNone;
            [self reset];
        }
        return self;
    }
    
    FEDanmuItem *item = self.watingForDisplayModelArray.firstObject;
    FEDanmuItemView *view = [self dequeReusableViewWithItem:item];
    
    [self addDanmuItemViewToSence:view];
    
    [self.watingForDisplayModelArray removeObject:item];
    
    return self;
}

- (FEDanmuSence *)attachSpeedToDanmuItemView:(FEDanmuItemView *)view {
    FEDanmuItemView *formerView = [self formerViewAtTrack:view.track];
    if (!formerView) {
        view.speed = kDefaultSpeed + arc4random_uniform(40);
    }
    else {
        CGFloat formerViewTime = CGRectGetMaxX(formerView.frame) / formerView.speed;
        CGFloat maxSpeed = CGRectGetMaxX(view.frame) / formerViewTime;
        
        CGFloat floatPercent = arc4random_uniform(50) / 100.0;
        
        CGFloat speed = formerView.speed + ((maxSpeed - formerView.speed)) * floatPercent;
        
        speed = MAX(kMinSpeed, MIN(speed, kSpeedLimit));

        view.speed = speed;
    }
    
    return self;
}

- (Track)applyTrackForDanmuItemView:(FEDanmuItemView *)view {
    Track nowMax = self.trackViewArray.count;
    
    // 轨道未使用满
    if (nowMax < self.trackLimit) {
        return nowMax;
    }
    else {
        NSArray *smallest = self.trackViewArray[0];
        for (int i = 1; i < self.trackViewArray.count; i++) {
            NSArray *array = self.trackViewArray[i];
            if (array.count < smallest.count) {
                smallest = array;
            }
        }
        return [self.trackViewArray indexOfObject:smallest];
    }
}

- (NSMutableArray *)trackViewArrayAtTrak:(Track)track {
    if (self.trackViewArray.count <= track) {
        [self.trackViewArray addObject:[NSMutableArray array]];
        return self.trackViewArray.lastObject;
    }
    else {
        return self.trackViewArray[track];
    }
}

- (FEDanmuItemView *)formerViewAtTrack:(Track)track {
    FEDanmuItemView *formerView = [[self trackViewArrayAtTrak:track] lastObject];
    
    return formerView;
}

- (FEDanmuSence *)addDanmuItemViewToSence:(FEDanmuItemView *)view {
    // 设置轨道
    view.track = [self applyTrackForDanmuItemView:view];
    
    // 设置起始位置
    [self attachPositionToDanmuItemView:view];
    
    // 设置速度
    [self attachSpeedToDanmuItemView:view];
    
    // 添加到轨道所在视图数组
    [[self trackViewArrayAtTrak:view.track] addObject:view];
    
    // 添加到幕布
    [self addSubview:view];
    
    // 添加view到正在使用的数组
    [self.usingViews addObject:view];
    
    return self;
}

- (FEDanmuSence *)attachPositionToDanmuItemView:(FEDanmuItemView *)view {
    CGFloat x = self.bounds.size.width;
    CGFloat y = self.trackHeight * view.track;
    FEDanmuItemView *formerView = [self formerViewAtTrack:view.track];
    if (formerView) {
        if (CGRectGetMaxX(formerView.frame) >= self.bounds.size.width) {
            x = CGRectGetMaxX(formerView.frame) + arc4random_uniform(20);
        }
    }
    
    CGRect frame = CGRectMake(x, y, view.bounds.size.width, view.bounds.size.height);
    
    view.frame = frame;
    
    return self;
}


- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [self.reuseViews removeAllObjects];
}

- (void)removeObserve {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
