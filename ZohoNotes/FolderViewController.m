//
//  FolderViewController.m
//  ZohoNotes
//
//  Created by BALACHANDAR on 21/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import "FolderViewController.h"
#import "AppDelegate.h"
#import "NotesViewController.h"
#import "UIImage+NotesImages.h"
#import "FolderCollectionViewCell.h"

#define segueToNotesViewController @"moveToNotesViewController"
#define reuseIdentifierForFolderTableView @"folderTableViewCell"
#define reuseIdentifierForFolderCollectionView @"folderCollectionViewCell"


@interface FolderViewController ()
{
    float widthOfScreen, heightOfScreen;
}
@end

@implementation FolderViewController
AppDelegate * appDelegate;


static const NSInteger  DELETE_BUTTON_TAG = 3000;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    widthOfScreen = self.view.frame.size.width;
    heightOfScreen = self.view.frame.size.height;
    
    _folderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.folderTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Actions

- (IBAction)menuBarButtonItemClicked:(id)sender {
    if (_folderTableView.isHidden) {
        _toogleBarButtonItem.image = [UIImage collectionViewBarButtonImage];
        _folderTableView.hidden = NO;
        _folderCollectionView.hidden = YES;
    }
    else
    {
        _toogleBarButtonItem.image = [UIImage tableViewBarButtonImage];
        _folderTableView.hidden = YES;
        _folderCollectionView.hidden = NO;
    }
}

-(void)addFolderButtonClicked:(id)sender
{
    UIAlertController * alertControllerToAddFolder = [UIAlertController alertControllerWithTitle: @"Add Folder" message: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertControllerToAddFolder addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Folder name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertControllerToAddFolder addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertControllerToAddFolder.textFields;
        UITextField * namefield = textfields[0];

        [self.fetchedResultsController managedObjectContext];
        Folder * eachFolder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
        
        // If appropriate, configure the new managed object.
        eachFolder.folderTitle = namefield.text;
        
        // Save the context.
        
        [appDelegate saveContext];
        
        
    }]];
    [alertControllerToAddFolder addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControllerToAddFolder animated:YES completion:nil];
}


- (IBAction)deleteButtonInCollectionViewClicked:(id)sender {
    
    UIButton * buttonAtIndex = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:buttonAtIndex.tag-DELETE_BUTTON_TAG inSection:0];
    [appDelegate.persistentContainer.viewContext deleteObject:[self.fetchedResultsController objectAtIndexPath:path]];
    [appDelegate saveContext];

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = reuseIdentifierForFolderTableView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    Folder *folder = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self configureCell:cell withFolder:folder];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [appDelegate.persistentContainer.viewContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [appDelegate saveContext];
        
    }
}


- (void)configureCell:(UITableViewCell *)cell withFolder : (Folder *) folder {
    cell.textLabel.text = folder.folderTitle.description;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"No. of Notes :%u", folder.notes.allObjects.count ];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    folderObjectForNextPage = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:segueToNotesViewController sender:self.folderTableView];
}
#pragma mark - UICollection View Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = reuseIdentifierForFolderCollectionView;
    
    FolderCollectionViewCell *folderCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    folderCollectionViewCell.layer.cornerRadius = 4;
    
    Folder *folder = [self.fetchedResultsController objectAtIndexPath:indexPath];
    folderCollectionViewCell.folderNameLabel.text = folder.folderTitle.description;
    folderCollectionViewCell.numberOfNotesLabel.text = [NSString stringWithFormat:@"No. of Notes :%u", folder.notes.allObjects.count ];;
    folderCollectionViewCell.deleteButton.tag = DELETE_BUTTON_TAG + indexPath.row;
    
    return folderCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((widthOfScreen-30)/2, (widthOfScreen-20)/2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    folderObjectForNextPage = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:segueToNotesViewController sender:self.folderCollectionView];

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Folder *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Folder *> *fetchRequest = Folder.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"folderTitle" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Folder *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_folderTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.folderTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.folderTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.folderTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withFolder:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.folderTableView endUpdates];
    [self.folderCollectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: segueToNotesViewController]) {
        NotesViewController * notesViewController = segue.destinationViewController;
        
        
        notesViewController.folderSelected = folderObjectForNextPage;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
