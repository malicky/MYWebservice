//
//  Persistence.h
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface YMPersistence : NSObject

+ (instancetype)sharedInstance;
- (instancetype)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;
- (void)saveContexts;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectContext *backgroundManagedObjectContext;

@end
