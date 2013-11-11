//
//  TopCell.m
//  Nemo
//
//  Created by Yashwant Chauhan on 10/24/13.
//  Copyright (c) 2013 Yashwant Chauhan. All rights reserved.
//

#import "ParentCell.h"

@interface ParentCell () {
    UIImageView *separatorLineView;
}
@end

@implementation ParentCell

- (void)awakeFromNib
{
	[super awakeFromNib];
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)drawRect:(CGRect)rect
{
    // Draw dotted border
    [self dottedSeparator];
}

@end
