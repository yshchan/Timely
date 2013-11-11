//
//  Task+Sections.m
//  OneWithNoTitle
//
//  Created by Yashwant Chauhan on 21/07/13.
//  Copyright (c) 2013 Yashwant Chauhan. All rights reserved.
//

#import "Task+Sections.h"
#import "NSDate+DateRange.h"
#import "NSDate+RelativeString.h"
#import "NSString+Extended.h"

@implementation Task (Sections)

-(NSString *)dateGroup {
    NSString *name = nil;
    NSDate *date = self.dateScheduled;
        
    if ([date isToday]) {
        name = @"Today";
    } else if ([date isThisWeek]) {
        name = @"This week";
    } else if ([date isNextWeek]) {
        name = @"Next Week";
    } else {
        name = @"Someday";
    }
    return name;
}

@end
