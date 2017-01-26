//
//  NotesViewController.m
//  ZohoNotes
//
//  Created by BALACHANDAR on 21/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import "NotesViewController.h"
#import "AppDelegate.h"
#import "UIImage+NotesImages.h"
#import "NotesDescriptionViewController.h"
#import "NotesCollectionViewCell.h"
#import "UIFont+CustomFonts.h"

#define segueToNotesDescriptionViewController @"SegueToDescription"
#define reuseIdentifierForNotesTableView @"notesTableViewCell"
#define reuseIdentifierForNotesCollectionView @"notesCollectionViewCell"


@interface NotesViewController ()
{
    AppDelegate * appDelegate;
    BOOL isDelete;
    float widthOfScreen, heightOfScreen;
    UILongPressGestureRecognizer *longPressGesture;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic,strong)  NSArray * notesArray;
@end

@implementation NotesViewController

static const NSInteger  DELETE_BUTTON_TAG = 3000;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    widthOfScreen = self.view.frame.size.width;
    heightOfScreen = self.view.frame.size.height;
    
    self.navigationController.navigationBarHidden = NO;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.title = self.folderSelected.folderTitle;
    _notesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadPage];
    [self addGestureRecognizerToCollectionView];
}


-(void)reloadPage
{
    _notesArray = self.folderSelected.notes.allObjects;
    for (Notes *  res in _notesArray) {
        NSLog(@"%@",res.notesDescription);
    }
    [self.notesTableView reloadData];
    [self.notesCollectionView reloadData];

}

-(void) addGestureRecognizerToCollectionView
{
    longPressGesture = [[UILongPressGestureRecognizer alloc]
                        initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = .5; // To detect after how many seconds you want shake the cells
    [self.notesCollectionView addGestureRecognizer:longPressGesture];
    
    longPressGesture.delaysTouchesBegan = YES;
    
    /// This will be helpful to restore the animation when clicked outside the cell
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(handleTap:)];
    tapGesture.enabled = NO;
    [self.notesCollectionView addGestureRecognizer:tapGesture];
}


-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    isDelete = NO;
    [self.notesCollectionView reloadData];
    tapGesture.enabled =NO;
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    isDelete = YES;
    [self.notesCollectionView reloadData];
    tapGesture.enabled =YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Actions

- (IBAction)menuBarButtonItemClicked:(id)sender {
    if (_notesTableView.isHidden) {
        _toggleBarButton.image = [UIImage collectionViewBarButtonImage];
        _notesTableView.hidden = NO;
        _notesCollectionView.hidden = YES;
    }
    else
    {
        _toggleBarButton.image = [UIImage tableViewBarButtonImage];
        _notesTableView.hidden = YES;
        _notesCollectionView.hidden = NO;
    }
}

-(void)addNotesButtonClicked:(id)sender{
    
    
    UIAlertController * alertControllerToAddNotes = [UIAlertController alertControllerWithTitle: @"Add Note" message: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertControllerToAddNotes addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Note name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertControllerToAddNotes addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertControllerToAddNotes.textFields;
        UITextField * namefield = textfields[0];

        Notes * eachNotes = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
        
        eachNotes.folderRealated = _folderSelected;
        
        // If appropriate, configure the new managed object.
        eachNotes.notesTitle = namefield.text;
        
        // Save the context.        
        [appDelegate saveContext];
        
        [self reloadPage];
        
    }]];
    [alertControllerToAddNotes addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    }]];
    [self presentViewController:alertControllerToAddNotes animated:YES completion:nil];
}


- (IBAction)deleteButtonInCollectionViewClicked:(id)sender {
    
    UIButton * buttonAtIndex = (UIButton *)sender;
    [appDelegate.persistentContainer.viewContext deleteObject:[self.folderSelected.notes.allObjects objectAtIndex:buttonAtIndex.tag - DELETE_BUTTON_TAG]];
    [appDelegate saveContext];
    [self reloadPage];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = reuseIdentifierForNotesTableView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    Notes *notes = [_notesArray objectAtIndex:indexPath.row];
    [self configureCell:cell withNotes:notes];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [appDelegate.persistentContainer.viewContext deleteObject:[self.folderSelected.notes.allObjects objectAtIndex:indexPath.row]];
        [appDelegate saveContext];
        [self reloadPage];
    }
}


- (void)configureCell:(UITableViewCell *)cell withNotes : (Notes *) notes {
    cell.textLabel.text = notes.notesTitle.description;
    cell.detailTextLabel.text = notes.notesDescription.description;
    
    cell.textLabel.font = [UIFont titleFont];
    cell.detailTextLabel.font = [UIFont descriptionFont];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    noteToBeSentToNextPage = [_notesArray objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:segueToNotesDescriptionViewController sender:nil];
}


#pragma mark - UICollection View Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_notesArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = reuseIdentifierForNotesCollectionView;
    
    NotesCollectionViewCell *notesCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     Notes *notes = [_notesArray objectAtIndex:indexPath.row];
    notesCollectionViewCell.layer.cornerRadius = 4;
    
    notesCollectionViewCell.notesNameLabel.text = notes.notesTitle.description;
    notesCollectionViewCell.notesDescriptionLabel.text = notes.notesDescription.description;
    
    if (notesCollectionViewCell.notesDescriptionLabel.text == nil || [notesCollectionViewCell.notesDescriptionLabel.text isEqualToString:@""])
    {
        notesCollectionViewCell.notesDescriptionLabel.text = @"No description";
    }
    
    notesCollectionViewCell.deleteButtonIncollectionView.tag = DELETE_BUTTON_TAG + indexPath.row;
    
    notesCollectionViewCell.notesNameLabel.font = [UIFont titleFont];
    notesCollectionViewCell.notesDescriptionLabel.font = [UIFont descriptionFont];
    
    NSLog(@"notes%@notes",notesCollectionViewCell.notesDescriptionLabel.text);

    if (isDelete)
    {
        CABasicAnimation* animationToDelete = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [animationToDelete setToValue:[NSNumber numberWithFloat:0.0f]];
        [animationToDelete setFromValue:[NSNumber numberWithDouble:M_PI/64]];
        [animationToDelete setDuration:0.1];
        [animationToDelete setRepeatCount:NSUIntegerMax];
        [animationToDelete setAutoreverses:YES];
        notesCollectionViewCell.layer.shouldRasterize = YES;
        [notesCollectionViewCell.layer addAnimation:animationToDelete forKey:@"SpringboardShake"];
        [notesCollectionViewCell.deleteButtonIncollectionView setHidden:NO];
    }
    else
    {
        [notesCollectionViewCell.deleteButtonIncollectionView setHidden:YES];
    }

    return notesCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((widthOfScreen-30)/2, (widthOfScreen-20)/2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    noteToBeSentToNextPage = [_notesArray objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:segueToNotesDescriptionViewController sender:nil];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString: segueToNotesDescriptionViewController]) {
        NotesDescriptionViewController * notesDescriptionViewController = segue.destinationViewController;
        notesDescriptionViewController.noteSelected = noteToBeSentToNextPage;
    }

}


@end
