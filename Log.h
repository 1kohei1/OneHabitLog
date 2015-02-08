//
//  Log.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/06.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Log : NSManagedObject

@property (nonatomic, retain) NSNumber * habit_id;
@property (nonatomic, retain) NSDate * date;

@end
