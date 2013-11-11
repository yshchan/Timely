//
//  Task.h
//  Todo
//
//  Created by Yashwant Chauhan on 11/2/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateScheduled;
@property (nonatomic, retain) NSNumber * isArchived;

@end
