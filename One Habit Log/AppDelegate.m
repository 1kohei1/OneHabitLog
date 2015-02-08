//
//  AppDelegate.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/04.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLog.h"
#import "Habit.h"
#import "Log.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStack];
//    [self allDelete];
//    [self seeHabit];
//    [self seeLog];
    
    return YES;
}

- (void)allDelete {
    // [MagicalRecord setupCoreDataStack];
    NSManagedObjectContext *magicalContext = [NSManagedObjectContext MR_defaultContext];

    NSArray *all = [Habit MR_findAll];
    int num = [all count];
    for (int i = 0; i < num; i++) {
        Habit *habit = [all objectAtIndex:i];
        [habit MR_deleteEntity];
    }
    
    NSArray *allLog = [Log MR_findAll];
    for (int i = 0; i < [allLog count]; i++) {
        Log *log = [allLog objectAtIndex:i];
        [log MR_deleteEntity];
    }
    [magicalContext MR_saveOnlySelfAndWait];
}

- (void) seeHabit {
    // [MagicalRecord setupCoreDataStack];
    NSArray *all = [Habit MR_findAll];
    int num = [all count];
    for (int i = 0; i < num; i++) {
        Habit *habit = [all objectAtIndex:i];
        NSLog(@"id: %@, title: %@, secret: %@, password: %@, selected: %@, deleted: %@", [habit valueForKey:@"id"], [habit valueForKey:@"title"], [habit valueForKey:@"secret"], [habit valueForKey:@"password"], [habit valueForKey:@"selected"], [habit valueForKey:@"deleted"]);
    }
    
}

- (void) seeLog {
    // [MagicalRecord setupCoreDataStack];
    NSArray *all = [Log MR_findAll];
    int num = [all count];

    for (int i = 0; i < num; i++) {
        Log *log = [all objectAtIndex:i];
        NSLog(@"habit_id: %@, nsdate: %@", [log valueForKey:@"habit_id"], [log valueForKey:@"date"]);
    }
    
    // insert date here
    /*
    // NSCalendar を取得します。
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    // NSDateComponents を作成して、そこに作成したい情報をセットします。
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    components.year = 2013;
    components.month = 12;
    components.day = 24;
    
    // NSCalendar を使って、NSDateComponents を NSDate に変換します。
    NSDate* date = [calendar dateFromComponents:components];
    
    UserLog *user_log = [[UserLog alloc]init];
    [user_log insertUserLog:[NSNumber numberWithInt:1] date:date];
     */
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [MagicalRecord cleanUp];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
