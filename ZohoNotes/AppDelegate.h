//
//  AppDelegate.h
//  ZohoNotes
//
//  Created by BALACHANDAR on 21/01/17.
//  Copyright © 2017 BALACHANDAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property NSManagedObjectContext *context;
- (void)saveContext;


@end

