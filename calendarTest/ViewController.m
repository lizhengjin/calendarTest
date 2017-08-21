//
//  ViewController.m
//  calendarTest
//
//  Created by liqi on 2017/8/3.
//  Copyright © 2017年 liqi. All rights reserved.
//

#import "ViewController.h"
#import "CustomPickView.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *daboArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"daboArr" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:dataPath];
    NSError *error;
    id questionnaireArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    self.daboArr = questionnaireArr[@"array"];
    NSLog(@"%@",self.daboArr);
    
//    NSString *dataPath2 = [[NSBundle mainBundle] pathForResource:@"daboData" ofType:@"json"];
//    NSData *data2 = [[NSFileManager defaultManager] contentsAtPath:dataPath2];
//    NSError *error2;
//    id questionnaireArr2 = [NSJSONSerialization JSONObjectWithData:data2 options:kNilOptions error:&error2];
//    NSLog(@"%@",questionnaireArr2);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    CustomPickView *selectTimeV = [[CustomPickView alloc] init];
    selectTimeV.dataArr = self.daboArr;
    selectTimeV.block = ^(NSString *timeStr) {
        label.text = timeStr;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:selectTimeV];
}


@end
