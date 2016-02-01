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
    // init arrays
    _modelArray = [NSMutableArray array];
    
    _watingForDisplayModelArray = [NSMutableArray array];
    
    _usingViews = [NSMutableArray array];
    
    _reuseViews = [NSMutableArray array];
    
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
    
    [self.updatePositionTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop mainRunLoop] addTimer:self.insertDanmuItemViewTimer forMode:NSDefaultRunLoopMode];
    
    [self.insertDanmuItemViewTimer fire];
    
    _state = FEDanmuSenceStatePlaying;
}

- (void)reset {
    self.watingForDisplayModelArray = self.modelArray.mutableCopy;
    
    [_updatePositionTimer invalidate];
    _updatePositionTimer = nil;
    
    [_insertDanmuItemViewTimer invalidate];
    _insertDanmuItemViewTimer = nil;
    
    for (FEDanmuItemView *subview in self.subviews) {
        [self danmuViewReachedLimitBounds:subview];
    }
    
    _state = FEDanmuSenceStateNone;
}

- (void)pause {
    if (self.state == FEDanmuSenceStatePause) return;
    
    [_updatePositionTimer invalidate];
    _updatePositionTimer = nil;
    
    [_insertDanmuItemViewTimer invalidate];
    _insertDanmuItemViewTimer = nil;
    
    _state = FEDanmuSenceStatePause;
}

- (void)restart {
    [self.updatePositionTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop mainRunLoop] addTimer:self.insertDanmuItemViewTimer forMode:NSDefaultRunLoopMode];
    
    [self.insertDanmuItemViewTimer fire];
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
        _insertDanmuItemViewTimer = [NSTimer timerWithTimeInterval:1.0 / 5 target:self selector:@selector(addNewDanmuToSence) userInfo:nil repeats:YES];
    }
    return _insertDanmuItemViewTimer;
}

#pragma mark private method
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

#warning 速度和初始位置有问题，待调整
- (FEDanmuSence *)attachSpeedToDanmuItemView:(FEDanmuItemView *)view {
    FEDanmuItemView *formerView = [self formerViewByItemView:view];
    if (!formerView) {
        view.speed = kDefaultSpeed + arc4random_uniform(40);
    }
    else {
        CGFloat formerViewTime = CGRectGetMaxX(formerView.frame) / formerView.speed;
        CGFloat maxSpeed = CGRectGetMaxX(view.frame) / formerViewTime;
        
        CGFloat floatPercent = arc4random_uniform(90) / 100.0;
        
        CGFloat speed = formerView.speed + ABS((maxSpeed - formerView.speed)) * floatPercent;
        if (speed > kSpeedLimit) {
            speed = kSpeedLimit - arc4random_uniform(40);
        }
        view.speed = speed;
    }
    
    return self;
}

- (FEDanmuItemView *)formerViewByItemView:(FEDanmuItemView *)view {
    FEDanmuItemView *formerView;
    for (FEDanmuItemView *subView in self.subviews) {
        CGRect rect1 = subView.frame;
        rect1.origin.x = 0;
        
        CGRect rect2 = view.frame;
        rect2.origin.x = 0;
        BOOL b = CGRectIntersectsRect(rect1, rect2);
        
        // 处在相似轨道
        if (b) {
            if ((formerView && CGRectGetMaxX(formerView.frame) <= CGRectGetMaxX(subView.frame))||!formerView) {
                formerView = subView;
            }
        }
    }
    
    return formerView;
}

- (FEDanmuSence *)addDanmuItemViewToSence:(FEDanmuItemView *)view {
    // 设置位置和速度
    FEDanmuSence *sence = [self attachPositionToDanmuItemView:view];
    [sence attachSpeedToDanmuItemView:view];
    
    // 添加到幕布
    [sence addSubview:view];
    
    // 添加view到正在使用的数组
    [self.usingViews addObject:view];
    
    return self;
}

- (FEDanmuSence *)attachPositionToDanmuItemView:(FEDanmuItemView *)view {
    CGFloat x = self.bounds.size.width + arc4random_uniform(50);
    
    CGFloat y = arc4random_uniform((u_int32_t)(self.bounds.size.height - view.bounds.size.height));
    
    CGRect frame = CGRectMake(x, y, view.bounds.size.width, view.bounds.size.height);
    
    FEDanmuItemView *former = [self formerViewByItemView:view];
    if (former) {
        BOOL intersect = CGRectIntersectsRect(former.frame, frame);
        if (intersect) {
            frame.origin.x = CGRectGetMaxX(former.frame) + arc4random_uniform(view.frame.size.width);
        }
    }
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
