//
//  CustomPickView.h
//  calendarTest
//
//  Created by liqi on 2017/8/3.
//  Copyright © 2017年 liqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickView : UIView

@property (nonatomic, copy) void (^block)(NSString *);

@property (nonatomic, strong) NSArray *dataArr;

@end
