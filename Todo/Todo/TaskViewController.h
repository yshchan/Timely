//
//  MasterViewController.h
//  Todo
//
//  Created by Yashwant Chauhan on 11/2/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface TaskViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
