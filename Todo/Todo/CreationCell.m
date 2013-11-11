//
//  CreationCell.m
//  Nemo
//
//  Created by Yashwant Chauhan on 10/30/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import "CreationCell.h"

@interface CreationCell () {
    UITapGestureRecognizer *_tapRec;
}
@end

@implementation CreationCell

@synthesize textLabel=_textLabel;

-(UITextView*)textLabel {
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    _textLabel.scrollEnabled = NO;
    _textLabel.editable = YES;
    _textLabel.selectable = YES;
    _textLabel.userInteractionEnabled = YES;
    
    return _textLabel;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x, y, width, height;
    x = 10; y = 6; width = self.bounds.size.width; height = self.bounds.size.height;
    
    _textLabel.frame = CGRectMake(x, y, width, height);
}

#pragma mark -

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

@end
