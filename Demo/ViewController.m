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
    NSArray *colors = @[[UIColor blueColor],[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor]];
    NSArray *texts = @[@"Hey Buddy",@"Are U ok Leibos!",@"Japanese Animation",@"Kirayamato",@"Happy New Year!"];
    for (int i = 0; i < 10; i++) {
        NSString *text = texts[arc4random_uniform((u_int32_t)texts.count)];
        FEDanmuItem *item = [FEDanmuItem itemWithText:text backgroundImage:nil actionType:FEDanmuItemActionTypeNormal contentType:FEDanmuItemContentTypeText attachView:nil];
        item.font = [UIFont systemFontOfSize:arc4random_uniform(5) + 20.f];
        item.textColor = colors[arc4random_uniform((u_int32_t)colors.count )];
        [items addObject:item];
    }
    
    FEDanmuSence *sence = [FEDanmuSence senceWithItems:items];
    
    sence.frame = CGRectMake(0, 20, self.view.bounds.size.width, 400);
    sence.backgroundColor = [UIColor grayColor];
    sence.repeatPlay = YES;
    
    [self.view addSubview:sence];
    
    self.sence = sence;
    self.sence.persecoundDanmu = 20;
    
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"start" forState:UIControlStateNormal];
    
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    start.frame = CGRectMake(10, CGRectGetMaxY(sence.frame) + 10, 80, 44);
    start.backgroundColor = [UIColor greenColor];
    
    UIButton *pause = [UIButton buttonWithType:UIButtonTypeCustom];
    [pause setTitle:@"pause" forState:UIControlStateNormal];
    
    [pause addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    pause.frame = CGRectMake(CGRectGetMaxX(start.frame) + 5, CGRectGetMinY(start.frame), 80, 44);
    pause.backgroundColor = [UIColor redColor];
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    [reset setTitle:@"reset" forState:UIControlStateNormal];
    
    [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    reset.frame = CGRectMake(CGRectGetMaxX(pause.frame) + 5, CGRectGetMinY(pause.frame), 80, 44);
    reset.backgroundColor = [UIColor blackColor];
    
    UIButton *insert = [UIButton buttonWithType:UIButtonTypeCustom];
    [insert setTitle:@"insert" forState:UIControlStateNormal];
    [insert addTarget:self action:@selector(insert) forControlEvents:UIControlEventTouchUpInside];
    insert.frame = CGRectMake(CGRectGetMaxX(reset.frame) + 5, CGRectGetMinY(reset.frame), 80, 44);
    insert.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:start];
    [self.view addSubview:reset];
    [self.view addSubview:pause];
    [self.view addSubview:insert];
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

- (void)insert {
    FEDanmuItem *item = [FEDanmuItem itemWithText:@"This is a insert text!" backgroundImage:nil actionType:FEDanmuItemActionTypeNormal contentType:FEDanmuItemContentTypeText attachView:nil];
    item.borderWidth = 2.f;
    item.borderColor = [UIColor blackColor];
    item.font = [UIFont systemFontOfSize:30];
    item.textColor = [UIColor yellowColor];
    [self.sence insertItem:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
