//
//  NotesCollectionViewCell.h
//  ZohoNotes
//
//  Created by BALACHANDAR on 22/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *notesNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButtonIncollectionView;

@end
