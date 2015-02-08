//
//  ViewController.m
//  TimesCalendar
//
//  Created by Kohei Arai on 2013/10/04.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TSQCalendarView *calendar = [[TSQCalendarView alloc]initWithFrame:self.view.bounds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *startString = @"2013-09-01";
    NSString *endString = @"2013-11-01";
    
    NSDate *startDate = [formatter dateFromString:startString];
    NSDate *endDate = [formatter dateFromString:endString];

    calendar.firstDate = startDate;
    calendar.lastDate = endDate;
    // 色情報を決定する
    calendar.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    
    [self.view addSubview:calendar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
