//
//  TaskCell.m
//  Todo
//
//  Created by Yashwant Chauhan on 11/2/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

@synthesize textLabel=_textLabel;

-(UILabel*)textLabel {
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    
    return _textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

@end
