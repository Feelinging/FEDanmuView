//
//  ViewController.m
//  FEDanmuView
//
//  Created by YamatoKira on 16/1/30.
//  Copyright © 2016年 feeling. All rights reserved.
//

#import "ViewController.h"
#import "FEDanmuView.h"

@interface ViewController ()

@property (nonatomic, strong) FEDanmuSence *sence;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *items = [NSMutableArray array];
    NSArray *colors = @[[UIColor greenColor],[UIColor redColor],[UIColor purpleColor],[UIColor blueColor]];
    for (int i = 0; i < 10000; i++) {
        FEDanmuItem *item = [FEDanmuItem itemWithText:@"hohdsiod" actionType:FEDanmuItemActionTypeNormal contentType:FEDanmuItemContentTypeText attachView:nil];
        item.font = [UIFont systemFontOfSize:arc4random_uniform(5) + 20.f];
        item.textColor = colors[arc4random_uniform((u_int32_t)colors.count - 1)];
        [items addObject:item];
    }
    
    FEDanmuSence *sence = [FEDanmuSence senceWithItems:items];
    
    sence.frame = CGRectMake(0, 10, self.view.bounds.size.width, 300);
    sence.backgroundColor = [UIColor whiteColor];
    sence.repeatPlay = YES;
    
    [self.view addSubview:sence];
    
    self.sence = sence;
    self.sence.persecoundDanmu = 2;
    
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"start" forState:UIControlStateNormal];
    
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    start.frame = CGRectMake(10, CGRectGetMaxY(sence.frame) + 10, 44, 44);
    start.backgroundColor = [UIColor grayColor];
    
    UIButton *pause = [UIButton buttonWithType:UIButtonTypeCustom];
    [pause setTitle:@"pause" forState:UIControlStateNormal];
    
    [pause addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    pause.frame = CGRectMake(CGRectGetMaxX(start.frame) + 5, CGRectGetMinY(start.frame), 44, 44);
    pause.backgroundColor = [UIColor greenColor];
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    [reset setTitle:@"reset" forState:UIControlStateNormal];
    
    [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    reset.frame = CGRectMake(CGRectGetMaxX(pause.frame) + 5, CGRectGetMinY(pause.frame), 44, 44);
    reset.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:start];
    [self.view addSubview:reset];
    [self.view addSubview:pause];
}

- (void)start {
    [self.sence start];
}

- (void)pause {
    [self.sence pause];
}

- (void)reset {
    [self.sence reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
