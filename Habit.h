//
//  Habit.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/06.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Habit : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * secret;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSNumber * deleted;

@end
