//
//  UserLog.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/05.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Habit.h"
#import "Log.h"

@interface UserLog : NSObject

/************ program about Habit ************/
// get habit by id, if 0 is given, return the latest one.
- (Habit *) getHabit:(NSNumber *) habit_id;

// create habit
- (Habit *) createHabit;

// update Habit
- (void) updateHabit:(NSNumber *)habit_id title:(NSString *)title secret:(NSNumber *)secret password:(NSString *)password;

// delete Habit
- (void)deleteHabit:(NSNumber *)habit_id;

// select habit
- (void)selectHabit:(NSNumber *) habit_id;

// get selected habit
- (Habit *)getSelectedHabit;

// get available Habit
- (NSArray *)getAvailableHabit;

- (NSArray *)getNotDeletedHabit;
/************ program about Habit end ************/


/************ program about Log ************/
// insert data
- (void) insertUserLog:(NSNumber *)habit_id date:(NSDate *)date;

// delete data
- (void) deleteUserLog:(NSNumber *)habit_id date:(NSDate *)date;

// returns if selected date is in record
-(BOOL) ifLogged:(NSNumber *)habit_id date:(NSDate *)date;

// get first log
-(Log *) getFirstLog:(NSNumber *) habit_id;
/************ program about Log end ************/


@end
