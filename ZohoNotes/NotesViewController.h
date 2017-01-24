//
//  NotesViewController.h
//  ZohoNotes
//
//  Created by BALACHANDAR on 21/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZohoNotes+CoreDataModel.h"

@class AppDelegate;

@interface NotesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, NSFetchedResultsControllerDelegate>
{
    Notes * noteToBeSentToNextPage;
}
@property (strong, nonatomic) IBOutlet UICollectionView *notesCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *notesTableView;
@property (weak, nonatomic) IBOutlet UIButton *addNotesButton;
@property (strong, nonatomic) NSFetchedResultsController<Notes *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleBarButton;


@property (nonatomic,strong) Folder * folderSelected;

- (IBAction)menuBarButtonItemClicked:(id)sender;

- (IBAction)addNotesButtonClicked:(id)sender;


@end
