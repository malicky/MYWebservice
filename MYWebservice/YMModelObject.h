//
//  MYModelObject.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface YMModelObject : NSManagedObject
+ (id)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;
@end
