//
//  UIFont+CustomFonts.h
//  ZohoNotes
//
//  Created by admin on 1/25/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (CustomFonts)

+(UIFont *) titleFont;
+(UIFont *) descriptionFont;
+(UIFont *) buttonFont;
+(UIFont *) textViewFontWithSize : (int) size;

@end
