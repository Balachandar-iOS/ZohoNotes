//
//  UIImage+NotesImages.m
//  SampleForKaaylabs
//
//  Created by admin on 1/19/17.
//  Copyright © 2017 Venugopal Devarala. All rights reserved.
//

#import "UIImage+NotesImages.h"

@implementation UIImage (NotesImages)

+(UIImage *) tickImage
{
    return [UIImage imageNamed:@"tickButton"];
}
+(UIImage *) closeImage
{
     return [UIImage imageNamed:@"clearButton"];
}
+(UIImage *) editImage
{
     return [UIImage imageNamed:@"editButton"];
}

+(UIImage *) plusIconToAddImage
{
     return [UIImage imageNamed:@"addImage"];
}

+(UIImage *) tableViewBarButtonImage;
{
    return [UIImage imageNamed:@"tableViewLayout"];
}
+(UIImage *) collectionViewBarButtonImage
{
    return [UIImage imageNamed:@"collectionViewLayout"];
}
@end
