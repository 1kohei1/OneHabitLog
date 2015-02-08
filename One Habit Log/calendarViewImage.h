//
//  calendarViewImage.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/12/04.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calendarViewImage : NSObject

// return calendar image
- (UIImage *)getCalendarImage:(NSNumber *)habit_id imageFrame:(CGRect )imageFrame;

// save calendar image
- (UIImage *)saveCalendarImage:(NSNumber *)habit_id imageFrame:(CGRect) imageFrame;

@end
