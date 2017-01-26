//
//  NotesDescriptionViewController.m
//  SampleForKaaylabs
//
//  Created by admin on 1/19/17.
//  Copyright © 2017 Venugopal Devarala. All rights reserved.
//

#import "NotesDescriptionViewController.h"
#import "UIImage+NotesImages.h"
#import "AddImagesCollectionViewCell.h"
#import "AppDelegate.h"
#import "GetLocationFromMapViewController.h"

@interface NotesDescriptionViewController ()
{
    AppDelegate * appDelegate;
    float widthOfScreen, heightOfScreen;
}

@end

@implementation NotesDescriptionViewController

static const NSInteger  ADD_IMAGE_VIEW_TAG = 2000;
static const NSInteger  DELETE_BUTTON_TAG = 3000;

#define segueToGetMapViewController @"GetMapLocation"


- (void)viewDidLoad {
    [super viewDidLoad];
    [self generalFunctions];
}

-(void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    
}

#pragma mark - General

-(void) generalFunctions
{
    self.navigationController.navigationBarHidden = NO;
    self.title = self.noteSelected.notesTitle;
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //Add Toolbar to textview keyboard
    UIToolbar *toolBarOverTextViewKeyboard = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)]; //should code with variables to support view resizing
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
    
    //using default text field delegate method here, here you could call
    
    [toolBarOverTextViewKeyboard setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    _notesTextview.inputAccessoryView = toolBarOverTextViewKeyboard;
    
    isEditing = NO;
    
    [self relodPage];
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    _notesTextview.layer.cornerRadius = 4;
    _notesImageCollectionView.layer.cornerRadius = 4;
    _locationButton.layer.cornerRadius = 4;

    //If description is already stored for this note
    if (_noteSelected.notesDescription != nil) {
    _notesTextview.text = _noteSelected.notesDescription;
    }
    [self changeTextviewHeightDynamically];

    
    
    //If Map coordinates is already stored for this note
    if (_noteSelected.mapImage != nil) {
        [_locationButton setBackgroundImage:[UIImage imageWithData:_noteSelected.mapImage] forState:UIControlStateNormal] ;
        _locationCoordinate.latitude = _noteSelected.latitude;
        _locationCoordinate.longitude = _noteSelected.longitude;
    }

    [self makeElementsDisabled];

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeElementsEnabled:)];
    [self.view addGestureRecognizer:singleFingerTap];

}

-(void)makeElementsDisabled
{
    _notesTextview.editable = NO;
    _locationButton.enabled = NO;
}
-(void) relodPage
{
    arrayWithImagesAdded = [NSMutableArray arrayWithArray:self.noteSelected.images.allObjects];
    [arrayWithImagesAdded addObject:[UIImage plusIconToAddImage]];
    [_notesImageCollectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//The event handling method
- (void)makeElementsEnabled:(UITapGestureRecognizer *)recognizer {
    isEditing = YES;
    recognizer.enabled = NO; // tap gesture disabled after enabling all the items
    _notesTextview.editable = YES;
    _locationButton.enabled = YES;
    [_notesImageCollectionView reloadData];

}


//Changing the height of the text view as per content
-(void) changeTextviewHeightDynamically
{
    CGFloat fixedWidth = _notesTextview.frame.size.width;
    CGSize newSize = [_notesTextview sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _notesTextview.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    _heightOfTextview.constant = newFrame.size.height;
    _notesScrollView.contentSize = CGSizeMake(widthOfScreen, newFrame.size.height + _notesImageCollectionView.frame.size.height + _locationButton.frame.size.height + 100);
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:segueToGetMapViewController]) {
     GetLocationFromMapViewController * getLocationViewController = segue.destinationViewController;
     NSLog(@"%f",_noteSelected.latitude);
     if (_locationCoordinate.latitude != 0.00 && _locationCoordinate.longitude !=0.00) {
         getLocationViewController.currentCoordinates = _locationCoordinate;
     }
     }
}



#pragma mark - ImagePicker

- (void)selectPhoto {
        [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (isEmptyImageSelected) {
        Images * images = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
        
        images.forNote = _noteSelected;
        
        NSData *imageDataFromIamge = UIImagePNGRepresentation(chosenImage);

        // If appropriate, configure the new managed object.
        images.imageData = imageDataFromIamge;
        
        // Save the context.
        
        [appDelegate saveContext];
        [arrayWithImagesAdded addObject:[UIImage plusIconToAddImage]];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self relodPage];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIButtonActions

- (IBAction)deleteButtonClicked:(id)sender {
    UIButton * buttonclicked = (UIButton *)sender;
    NSLog(@"%ld",(long)buttonclicked.tag);
    [appDelegate.persistentContainer.viewContext deleteObject:[self.noteSelected.images.allObjects objectAtIndex:buttonclicked.tag - DELETE_BUTTON_TAG]];
    
    [appDelegate saveContext];
    
    [self relodPage];

}

- (IBAction)locationButtonclicked:(id)sender {
    [self performSegueWithIdentifier:segueToGetMapViewController sender:nil];
}

- (IBAction)fontSliderValueChanged:(id)sender {
    _fontSlider = (UISlider *)sender;
    NSLog(@"%f",_fontSlider.value);
    int fontForTextView = _fontSlider.value;
    _notesTextview.font = [UIFont systemFontOfSize:fontForTextView];
    [self changeTextviewHeightDynamically];
    
}
- (IBAction)fontBarButtonItemclicked:(id)sender {
    if (_fontSlider.isHidden) {
        _fontSlider.hidden = NO;
    }
    else
    {
        _fontSlider.hidden = YES;
    }
}

-(void)doneButtonClicked
{
    [_notesTextview resignFirstResponder];
}

- (IBAction)backButtonclicked:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Collection View


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.height - 20, collectionView.frame.size.height - 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayWithImagesAdded count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddImagesCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addImagesCollecrionViewCell" forIndexPath:indexPath];
 
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.addImageview.tag = ADD_IMAGE_VIEW_TAG+ indexPath.row;
    cell.deleteButtonInCollectionView.tag = DELETE_BUTTON_TAG+indexPath.row;
    
    
    if (indexPath.row == arrayWithImagesAdded.count - 1) {
        cell.addImageview.image = [arrayWithImagesAdded objectAtIndex:indexPath.row];
    }
    else
    {
        Images * imagesAtIndex =[arrayWithImagesAdded objectAtIndex:indexPath.row];
        UIImage *image = [UIImage imageWithData:imagesAtIndex.imageData];
        cell.addImageview.image = image;
    }
    
    if (indexPath.row == arrayWithImagesAdded.count-1 || !isEditing) {
        cell.deleteButtonInCollectionView.hidden = YES;
    }
    else{
        cell.deleteButtonInCollectionView.hidden = NO;
    }
    
   
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditing) {
        indexSelected    = (int)indexPath.row;
        if (indexSelected == arrayWithImagesAdded.count-1) {
            isEmptyImageSelected = YES;
            [self selectPhoto];
        }
    }
}


#pragma mark - Unwind Segue

- (IBAction)unwindFromMapToNotesDescriptionViewController:(UIStoryboardSegue *)unwindSegue
{
    [_locationButton setBackgroundImage:_mapImage forState:UIControlStateNormal];
    _locationButton.imageView.image = _mapImage;
    
    if (_locationCoordinate.latitude != 0.00) {
        _noteSelected.latitude = _locationCoordinate.latitude;
        _noteSelected.longitude = _locationCoordinate.longitude;
        
        NSData *imageDataFromIamge = UIImagePNGRepresentation(_mapImage);
        
        _noteSelected.mapImage = imageDataFromIamge;
        NSLog(@"imageFromMap %@",imageDataFromIamge);
        [appDelegate saveContext];
    }

}

#pragma mark - UITextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView isEqual: _notesTextview]) {
        [self changeTextviewHeightDynamically];
        if ([textView.text isEqualToString:@"Enter description"]) {
            textView.text = @"";
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual: _notesTextview]) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Enter description";
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView isEqual: _notesTextview]) {
        [self changeTextviewHeightDynamically];
        if (![_notesTextview.text isEqualToString:@"Enter description"]) {
            _noteSelected.notesDescription = _notesTextview.text;
            [appDelegate saveContext];
        }
    }
}

@end
