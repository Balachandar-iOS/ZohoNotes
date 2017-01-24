//
//  FolderCollectionViewCell.h
//  ZohoNotes
//
//  Created by BALACHANDAR on 22/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *folderNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfNotesLabel;

@end
