//
//  MasterViewController.m
//  Todo
//
//  Created by Yashwant Chauhan on 11/2/13.
//  Copyright (c) 2013 NorthStar. All rights reserved.
//

#import "TaskViewController.h"

#import "DetailViewController.h"

#import "Task.h"
#import "CreationCell.h"

@interface TaskViewController () {
    NSDictionary *_newlyCreatedCell;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TaskViewController

#pragma mark - View

-(void)loadNavigationbar {
    self.title = @"Todo";
    self.navigationController.navigationBar.translucent = NO;
}

-(void)loadToolbar {
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.translucent = NO;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewObject:)];
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashArchived:)];
    self.toolbarItems = [NSArray arrayWithObjects:trashButton,flexibleSpace,addButton, nil];
}

-(void)loadTableview {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self fetchObjects];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
}

// ok, a special exception for the text view in the cell...
-(void)tap:(UITapGestureRecognizer *)tapRec {
    
    [[self view] endEditing: YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchObjects];
    
    [self loadNavigationbar];
    [self loadToolbar];
    [self loadTableview];
}

#pragma mark - Text View

-(void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    CreationCell *cell = (CreationCell*)[textView.superview.superview superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Task *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // update object
    object.title = textView.text;
    
    NSDate __block *dateScheduled = object.dateScheduled;
    
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:&error];
    
    [detector enumerateMatchesInString:object.title options:kNilOptions range:NSMakeRange(0, [object.title length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        dateScheduled = result.date;
    }];
    
    object.dateScheduled = dateScheduled;
    object.isArchived = @(NO);
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"'%@' saved...",[object description]);
    }];
}

#pragma mark - Memory

// TODO: when cell & object is added, highlight it and make the textLabel first responder.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchObjects {
    // ascending: NO (latest first)
    // ascending: YES (oldest first)
    
    self.fetchedResultsController = [Task MR_fetchAllSortedBy:@"dateScheduled" ascending:YES withPredicate:nil groupBy:@"dateGroup" delegate:self inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

-(void)addNewObject:(id)sender {
    [self performSelectorOnMainThread:@selector(insertNewObject:) withObject:sender waitUntilDone:YES];
}

- (void)insertNewObject:(id)sender
{
    Task *object = [Task MR_createEntity];
    object.dateScheduled = [NSDate date]; // use a dummy date
    object.title = @"Tap to edit me!"; // dummy, dummy, dummy!!
    object.isArchived = @(NO);
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"'%@' saved...",[object description]);
    }];
}

-(void)trashArchived:(id)sender {    
//    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext){
//        [allArchivedTasks MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
//        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
//    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSString *name = [sectionInfo name];
    return name;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = tableView.rowHeight;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)completeTask:(UISwipeGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        // complete task
        CGPoint swipeLocation = [sender locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        
        CreationCell *cell = (CreationCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        
        NSDictionary *attrs = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSFontAttributeName:[cell.textLabel font],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        
        NSAttributedString *strikedAttributedString = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:attrs];
        cell.textLabel.attributedText = strikedAttributedString;
        
        Task *selectedTask = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
        // selectedTask.isArchived = @(YES);
        
        // delete task :(
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext){
            [selectedTask MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
        }];
    }
}

-(void)cancelTask:(UISwipeGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        // undo task
        CGPoint swipeLocation = [sender locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        
        CreationCell *cell = (CreationCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        
        NSDictionary *strikethroughAttributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSFontAttributeName:[cell.textLabel font],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        
        NSMutableAttributedString *strikedAttributedString = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text attributes:strikethroughAttributes];
        
        if ([cell.textLabel.attributedText isEqualToAttributedString:strikedAttributedString]) {
            [strikedAttributedString removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, [cell.textLabel.text length])]; // remove strikethrough
            [strikedAttributedString removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [cell.textLabel.text length])]; // remove lightgray
            cell.textLabel.attributedText = strikedAttributedString;
            
            // Task *selectedTask = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
            // selectedTask.isArchived = @(NO);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            // highlight cell
            // [tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            // [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
            
            // insert cell
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(CreationCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // setup actions (swipe)
    UISwipeGestureRecognizer *cancelTaskSwipeRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTask:)];
    cancelTaskSwipeRec.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:cancelTaskSwipeRec];
    
    UISwipeGestureRecognizer *completeTaskSwipeRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(completeTask:)];
    completeTaskSwipeRec.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:completeTaskSwipeRec];
    
    // setup cell
    Task *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.delegate = self;
    cell.textLabel.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.textLabel.tag = 7337;
    cell.textLabel.text = object.title;
}

@end
