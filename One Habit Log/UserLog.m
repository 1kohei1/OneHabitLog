//
//  UserLog.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/05.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "UserLog.h"

@implementation UserLog

- (Habit *) getHabit:(NSNumber *)habit_id {

    // [MagicalRecord setupCoreDataStack];
    
    NSArray *all = [Habit MR_findAll];
    
    if ([all count] == 0) {
        return nil;
    } else if (habit_id == 0) { // 一番最新のものを返す
        return [all lastObject];
    } else if ([habit_id isEqualToNumber:[NSNumber numberWithInt:-100]]) { // 新しいHabitを返す
        return [self createHabit];
    } else { // habit_idがセットされているから、その最新を返す。
        for (int i = 0; i < [all count]; i++) {
            Habit *habit = [all objectAtIndex:i];
            
            if (habit.id == habit_id) {
                return habit;
            }
        }
    }
    return nil;
}

// create habit
- (Habit *)createHabit {
    // [MagicalRecord setupCoreDataStack];
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];
    
    NSArray *all = [Habit MR_findAll];
    Habit *habit = [Habit MR_createEntity];

    habit.id = [NSNumber numberWithInt:[all count] == 0 ? 1 : [all count] + 1];
    habit.title = NSLocalizedString(@"habit.title", Nil);
    habit.secret = [NSNumber numberWithBool:NO];
    habit.password = @"0000";
    habit.selected = [NSNumber numberWithBool:YES];
    habit.deleted = [NSNumber numberWithBool:NO];

    [magicalContext MR_saveOnlySelfAndWait];
    
    return habit;
}

// insert data
- (void) insertUserLog:(NSNumber *)habit_id date:(NSDate *)date {
   // [MagicalRecord setupCoreDataStack];
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];

    Log *log = [Log MR_createEntity];
    log.habit_id = habit_id;
    log.date = date;
    
    [magicalContext MR_saveOnlySelfAndWait];
}

// delete data
- (void) deleteUserLog:(NSNumber *)habit_id date:(NSDate *)date {
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];

    Log *log = [Log MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(habit_id == %@) AND (date == %@)", habit_id, date]];
    [log MR_deleteEntity];
    
    [magicalContext MR_saveOnlySelfAndWait];
}

// returns if selected date is in record
-(BOOL) ifLogged:(NSNumber *)habit_id date:(NSDate *)date {
    Log *log = [Log MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"(habit_id == %@) AND (date == %@)", habit_id, date]];
    return (log ? YES : NO);
}

- (Log *)getFirstLog:(NSNumber *)habit_id {
    // [MagicalRecord setupCoreDataStack];

    NSArray *sortedLog = [Log MR_findAllSortedBy:@"date" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"habit_id == %@", habit_id]];
    return sortedLog ? [sortedLog firstObject] : nil;
}

// 
- (void) updateHabit:(NSNumber *)habit_id title:(NSString *)title secret:(NSNumber *)secret password:(NSString *)password {
    // [MagicalRecord setupCoreDataStack];
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];
    
    Habit *habit = [self getHabit:habit_id];
    habit.title = title;
    habit.secret = secret;
    habit.password = password;
    
    [magicalContext MR_saveOnlySelfAndWait];
}

// delete habit
- (void)deleteHabit:(NSNumber *)habit_id {
    // [MagicalRecord setupCoreDataStack];
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];
    
    // 消去するHabitを取得
    Habit *habit = [self getHabit:habit_id];
    
    // Logを消去
    NSArray *deleteLog = [Log MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"habit_id == %@", habit.id]];
    for (int i = 0; i < [deleteLog count]; i++) {
        Log *log = [deleteLog objectAtIndex:i];
        [log MR_deleteEntity];
    }
    
    // Habitを消去
    [habit MR_deleteEntity];

    [magicalContext MR_saveOnlySelfAndWait];
}

// select habit
- (void)selectHabit:(NSNumber *)habit_id {
    // [MagicalRecord setupCoreDataStack];
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];
    
    NSArray *allHabit = [self getNotDeletedHabit];
    for (int i = 0; i < [allHabit count]; i++) {
        Habit *habit = [allHabit objectAtIndex:i];
        habit.selected = [NSNumber numberWithBool:(habit.id == habit_id ? YES : NO)];
    }
    [magicalContext MR_saveOnlySelfAndWait];
}

// get selected habit
- (Habit *)getSelectedHabit {
    // [MagicalRecord setupCoreDataStack];
    
    NSArray *allHabit = [self getNotDeletedHabit];
    for (int i = 0; i < [allHabit count]; i++) {
        Habit *habit = [allHabit objectAtIndex:i];
        if ([habit.selected boolValue]) {
            return habit;
        }
    }
    return nil;
}

// get available habit
- (NSArray *)getAvailableHabit {
    // [MagicalRecord setupCoreDataStack];
    
    NSArray *habits = [Habit MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(secret == 0) AND (deleted == 0)"]];
    return habits;
}

- (NSArray *)getNotDeletedHabit {
    // [MagicalRecord setupCoreDataStack];

    NSArray *habits = [Habit MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(deleted == %@)", [NSNumber numberWithBool:NO]]];
    return habits;
}

@end
