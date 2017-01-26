//
//  UIFont+CustomFonts.m
//  ZohoNotes
//
//  Created by admin on 1/25/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import "UIFont+CustomFonts.h"

@implementation UIFont (CustomFonts)


+(UIFont *)titleFont
{
   return [UIFont boldSystemFontOfSize:17];
}

+(UIFont *)descriptionFont
{
    return [UIFont italicSystemFontOfSize:12];
}

+(UIFont *) buttonFont
{
    return [UIFont fontWithName:@"Copperplate" size:13];
}

+(UIFont *) textViewFontWithSize : (int) size
{
    return [UIFont fontWithName:@"Roboto-LightItalic" size:size];
}
@end
