//
//  calendarViewImage.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/12/04.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "calendarViewImage.h"
#import "TSQCalendarView.h"
#import "UserLog.h"

@implementation calendarViewImage {
    NSString *imagePath;
    UserLog *user_log;
}

- (id)init {
    imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    user_log = [[UserLog alloc]init];
    
    return self;
}

// return calendar image
- (UIImage *)getCalendarImage:(NSNumber *)habit_id imageFrame:(CGRect )imageFrame {

    // habit_idを指定して画像を取りにいく。
    NSString *calendarImagePath = [NSString stringWithFormat:@"%@/habit_%@.png", imagePath, habit_id];
    NSData *imageData = [NSData dataWithContentsOfFile:calendarImagePath];
    UIImage *image = [[UIImage alloc]initWithData: imageData];
    
    if (image) {
        return image;
    } else {
        image = [self saveCalendarImage:habit_id imageFrame:imageFrame];
        return image;
    }
}

// save calendar image
- (UIImage *)saveCalendarImage:(NSNumber *)habit_id imageFrame:(CGRect) imageFrame {
    // カレンダーを作成
    UIView *calendar = [self returnCalendarView:habit_id imageFrame:imageFrame];
    // カレンダーを画像に変換
    UIImage *calendarImage = [self convertToUIImage:calendar];
    // 画像を保存
    [self saveUIImage:calendarImage habit_id:habit_id];
    
    return calendarImage;
}

/************ other methods ************/
// 指定されたidのカレンダーの今月分のviewを返す
- (UIView *)returnCalendarView:(NSNumber *)habit_id imageFrame:(CGRect ) imageFrame {
    TSQCalendarView *calendar = [[TSQCalendarView alloc]initWithFrame:imageFrame];
    calendar.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1];
    
    calendar.habit_id = habit_id;
    calendar.firstDate = [NSDate date];
    calendar.lastDate = [NSDate date];
    
    return calendar;
}

// convert UIView to UIImage
- (UIImage *)convertToUIImage:(UIView *)calendar {
    UIGraphicsBeginImageContext(calendar.frame.size);
    [calendar.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// save UIImage to HomeDirectory
- (void) saveUIImage:(UIImage *)calendarImage habit_id:(NSNumber *)habit_id {
    NSData *imageData = UIImagePNGRepresentation(calendarImage);
    
    NSString *savingImagePath = [NSString stringWithFormat:@"%@/habit_%@.png", imagePath, habit_id];
    [imageData writeToFile:savingImagePath atomically:YES];
}


@end
