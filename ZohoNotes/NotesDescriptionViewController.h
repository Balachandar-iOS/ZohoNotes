//
//  NotesDescriptionViewController.h
//  SampleForKaaylabs
//
//  Created by admin on 1/19/17.
//  Copyright © 2017 Venugopal Devarala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZohoNotes+CoreDataModel.h"


@interface NotesDescriptionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    int indexSelected;
    NSMutableArray * arrayWithImagesAdded;
    BOOL isEditing,isEmptyImageSelected;
    UIImagePickerController *imagePickerController;
    
}
@property (weak, nonatomic) IBOutlet UISlider *fontSlider;

@property (nonatomic,strong) Folder * folderSelected;
@property (nonatomic,strong) Notes * noteSelected;

@property (strong, nonatomic) IBOutlet UITextView *notesTextview;
@property (strong, nonatomic) IBOutlet UICollectionView *notesImageCollectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *notesScrollView;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTextview;

@property CLLocationCoordinate2D locationCoordinate;
@property UIImage * mapImage;

- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)locationButtonclicked:(id)sender;
- (IBAction)fontSliderValueChanged:(id)sender;



@end
