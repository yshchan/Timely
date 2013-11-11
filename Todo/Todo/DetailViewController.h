//
//  DetailViewController.h
//  Todo
//
//  Created by Yashwant Chauhan on 11/2/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
