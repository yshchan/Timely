//
//  UITextView+Lines.m
//  Todo
//
//  Created by Yashwant Chauhan on 11/5/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import "UITextView+Lines.h"

@implementation UITextView (Lines)

-(float)numberOfLines; {
    return self.contentSize.height/self.font.lineHeight;
}

@end
