# FEDanmuView

## 结构介绍

基于MVC思想

类: FEDanmuItem(Model) , FEDanmuItemView(View),FEDanmuSence(Controller)

##### FEDanmuItem

``` 
/**
 *  构造方法
 *
 *  @param text        文字内容
 *  @param actionType  弹幕的行为类型
 *  @param contentType 弹幕的内容类型
 *  @param attachView  弹幕会直接显示这个View
 */
+ (instancetype)itemWithText:(NSString *)text
                  actionType:(FEDanmuItemActionType)ationType
                 contentType:(FEDanmuItemContentType)contentType
                  attachView:(UIView *)attachView;
                  
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
    FEDanmuItemActionTypeSuspend = 1, (还未实现该类型的特殊显示效果)
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
```

FEDanmuItemView: 作为MVC架构里的View层用于显示弹幕，实际使用中可能不需要接触这个类

``` 
/**
 *  构造方法
 *
 *  @param item 弹幕模型
 */
+ (instancetype)itemViewWithItem:(FEDanmuItem *)item;
```

FEDanmuSence: 作为MVC架构里面的Controller，用于控制弹幕的显示速度，发射频率，刷新帧率等

``` 
/**
 *  构造方法
 *
 *  @param items 弹幕模型数组
 */
+ (instancetype)senceWithItems:(NSArray<FEDanmuItem *> *)items;
```



## 如何构造一个弹幕幕布

``` 
// items
NSMutableArray *items = [NSMutableArray array];
NSArray *colors = @[[UIColor blueColor],[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor]];
NSArray *texts = @[@"Hey Buddy",@"Are U ok Leibos!",@"Japanese Animation",@"Kirayamato",@"Happy New Year!"];
for (int i = 0; i < 10000; i++) {
    NSString *text = texts[arc4random_uniform((u_int32_t)texts.count)];
    FEDanmuItem *item = [FEDanmuItem itemWithText:text actionType:FEDanmuItemActionTypeNormal contentType:FEDanmuItemContentTypeText attachView:nil];
    item.font = [UIFont systemFontOfSize:arc4random_uniform(5) + 20.f];
    item.textColor = colors[arc4random_uniform((u_int32_t)colors.count )];
    [items addObject:item];
}
// FEDanmuSence
FEDanmuSence *sence = [FEDanmuSence senceWithItems:items];
```

## 控制弹幕的显示

To start display danmu use

``` 
- (void)start;
```

To pause display danmu use

``` 
- (void)pause;
```

To reset FEDanmuSence use

``` 
- (void)reset;
```

Also u can insert a danmu immediately

``` 
- (void)insertItem:(FEDanmuItem *)item;
```

![image](https://d1zjcuqflbd5k.cloudfront.net/files/acc_459965/12gqt?response-content-disposition=inline;%20filename=Screen%20Capture%20on%202016-02-03%20at%2016-11-22.gif&Expires=1454487492&Signature=DF-LHN6hufrGt7DhIYe1H4antf~KDwqxv1ZKFiVawS-gHYa0s0n8vPuWKfSaEPkAhW5Qy9-natJrObiB0zFVhGeATK5Q1PSECJ2R22wfrmX-NFB7CbC4Qf2xzmJKdbYPp-vgEQRN1rk0fyLeQV06gYah4xnPoF-ujtxuKqS8nSU_&Key-Pair-Id=APKAJTEIOJM3LSMN33SA)



## License

Under MIT License