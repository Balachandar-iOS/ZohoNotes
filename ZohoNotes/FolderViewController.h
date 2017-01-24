//
//  FolderViewController.h
//  ZohoNotes
//
//  Created by BALACHANDAR on 21/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZohoNotes+CoreDataModel.h"

@class AppDelegate;

@interface FolderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, NSFetchedResultsControllerDelegate>
{
    Folder * folderObjectForNextPage;
}
@property (strong, nonatomic) IBOutlet UICollectionView *folderCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *folderTableView;
@property (weak, nonatomic) IBOutlet UIButton *addFolderButton;
@property (strong, nonatomic) NSFetchedResultsController<Folder *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toogleBarButtonItem;




- (IBAction)menuBarButtonItemClicked:(id)sender;

- (IBAction)addFolderButtonClicked:(id)sender;

@end
