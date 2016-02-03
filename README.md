# FEDanmuView

## Inilization

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

## Control the Display

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