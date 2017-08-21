//
//  CustomPickView.m
//  calendarTest
//
//  Created by liqi on 2017/8/3.
//  Copyright © 2017年 liqi. All rights reserved.
//

#import "CustomPickView.h"
#import "UIView+LayoutMethods.h"
#import "NSDate+LXBExtension.h"

#define YFScreen [UIScreen mainScreen].bounds.size
@interface CustomPickView ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

{
    NSInteger yearIndex;
    
    NSInteger monthIndex;
    
    NSInteger dayIndex;
    
    UIView *topV;
}
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

//@property (nonatomic, strong) NSString *year;

@end
@implementation CustomPickView

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    _dataDict = [[NSMutableDictionary alloc] init];
    _yearArray = [NSMutableArray array];
    //取出所有的年 放进yearArr里
    for (NSString *dateStr in _dataArr) {
        if (![_yearArray containsObject:[dateStr substringWithRange:NSMakeRange(0, 4)]]) {
            [_yearArray addObject:[dateStr substringWithRange:NSMakeRange(0, 4)]];
        }
    }
    NSMutableDictionary *yearDict = [[NSMutableDictionary alloc] init];
    for (NSString *year in _yearArray) {
        NSMutableArray *monthArr = [NSMutableArray array];
        for (NSString *dateStr in _dataArr) {
            if ([year isEqualToString:[dateStr substringWithRange:NSMakeRange(0, 4)]]) {
                if (![monthArr containsObject:[dateStr substringWithRange:NSMakeRange(5, 2)]]) {
                    [monthArr addObject:[dateStr substringWithRange:NSMakeRange(5, 2)]];
                }
            }
        }
        for (NSString *month in monthArr) {
            NSMutableArray *dayArr = [NSMutableArray array];
            for (NSString *dateStr in _dataArr) {
                if ([year isEqualToString:[dateStr substringWithRange:NSMakeRange(0, 4)]]) {
                    if ([month isEqualToString:[dateStr substringWithRange:NSMakeRange(5, 2)]]) {
                        [dayArr addObject:[dateStr substringWithRange:NSMakeRange(8, 2)]];
                    }
                }
            }
            
            //here
            [yearDict setObject:dayArr forKey:month];
            [_dataDict setObject:yearDict forKey:year];
        }
        yearDict = [[NSMutableDictionary alloc] init];
    }
    NSLog(@"%@",_dataDict);
}

- (instancetype)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        
        topV = [[UIView alloc] initWithFrame:CGRectMake(0, YFScreen.height, YFScreen.width, 40)];
        topV.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [self addSubview:topV];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 100, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0.62f green:0.62f blue:0.62f alpha:1.00f] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [topV addSubview:cancelBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,250,40}];;
        titleLabel.text = @"请选择日期";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.centerX = topV.width/2;
        [topV addSubview:titleLabel];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.frame = CGRectMake(YFScreen.width - 100, 0,100, 40);
        [yesBtn setTitle:@"完成" forState:UIControlStateNormal];
        [yesBtn setTitleColor:[UIColor colorWithRed:0.99f green:0.44f blue:0.00f alpha:1.00f] forState:UIControlStateNormal];
        [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [yesBtn addTarget:self action:@selector(yesBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [topV addSubview:yesBtn];

        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topV.frame.size.height + topV.frame.origin.y, YFScreen.width, 207)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
        [_pickerView selectRow:0 inComponent:0 animated:YES];
        [_pickerView selectRow:0 inComponent:1 animated:YES];
        [_pickerView selectRow:0 inComponent:2 animated:YES];
        
        [self pickerView:_pickerView didSelectRow:0 inComponent:0];
        [self pickerView:_pickerView didSelectRow:0 inComponent:1];
        [self pickerView:_pickerView didSelectRow:0 inComponent:2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *label = (UILabel *)[_pickerView viewForRow:0 forComponent:0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            
            label = (UILabel *)[_pickerView viewForRow:0 forComponent:1];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            
            label = (UILabel *)[_pickerView viewForRow:0 forComponent:2];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
        });
        
        [UIView animateWithDuration:0.25 animations:^{
            
            topV.frame = CGRectMake(0, YFScreen.height - 247, YFScreen.width, 40);
            _pickerView.frame = CGRectMake(0, topV.frame.size.height + topV.frame.origin.y, YFScreen.width, 207);
        }];
        
    }
    return self;
}

#pragma mark -UIPickerView
#pragma mark UIPickerView的数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray.count;
    }else if(component == 1) {
        NSString *year = _yearArray[yearIndex];
        NSDictionary *yearDict = self.dataDict[year];
        return yearDict.allKeys.count;
    }else {
        NSString *year = _yearArray[yearIndex];
        NSDictionary *yearDict = self.dataDict[year];
        NSArray *monthKeyArr = yearDict.allKeys;
        monthKeyArr = (NSMutableArray *)[monthKeyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        NSArray *monthArr = yearDict[monthKeyArr[monthIndex]];
        return monthArr.count;
    }
}

- (void)remove
{
    [UIView animateWithDuration:0.25 animations:^{
        topV.frame = CGRectMake(0, YFScreen.height, YFScreen.width, 40);
        _pickerView.frame = CGRectMake(0,topV.frame.size.height + topV.frame.origin.y, YFScreen.width, 207);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -UIPickerView的代理

// 滚动UIPickerView就会调用  选中行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        yearIndex = row;
        monthIndex = 0;
        dayIndex = 0;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:dayIndex inComponent:1 animated:YES];
        [pickerView selectRow:dayIndex inComponent:2 animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            
            label = (UILabel *)[pickerView viewForRow:monthIndex forComponent:1];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            
            label = (UILabel *)[pickerView viewForRow:dayIndex forComponent:2];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
        });
        
    }else if (component == 1) {
        monthIndex = row;
        dayIndex = 0;
        [pickerView reloadComponent:2];
        [pickerView selectRow:dayIndex inComponent:2 animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            
            label = (UILabel *)[pickerView viewForRow:dayIndex forComponent:2];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
        });
    }else {
        dayIndex = row;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
        });
    }
}

// 给pickerView 设置 每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor grayColor];
    genderLabel.font = [UIFont systemFontOfSize:14];
    if (component == 0){
        genderLabel.text = self.yearArray[row];
    }else if (component == 1){
        NSString *year = _yearArray[yearIndex];
        NSDictionary *yearDict = self.dataDict[year];
        NSArray *monthKeyArr = yearDict.allKeys;
        monthKeyArr = (NSMutableArray *)[monthKeyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        genderLabel.text = monthKeyArr[row];
    }else {
        NSString *year = _yearArray[yearIndex];
        NSDictionary *yearDict = self.dataDict[year];
        NSArray *monthKeyArr = yearDict.allKeys;
        monthKeyArr = (NSMutableArray *)[monthKeyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        NSArray *monthArr = yearDict[monthKeyArr[monthIndex]];
        genderLabel.text = monthArr[row];
    }
    
    return genderLabel;
}
- (void)yesBtnClick
{
    if (_block) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00:00",((UILabel *)[_pickerView viewForRow:yearIndex forComponent:0]).text, ((UILabel *)[_pickerView viewForRow:monthIndex forComponent:1]).text, ((UILabel *)[_pickerView viewForRow:dayIndex forComponent:2]).text];
        _block(timeStr);
        
    }
    [self remove];
}

- (void)cancelBtnClick
{
    if (_block) {
        _block(nil);
    }
    
    [self remove];
}

@end
