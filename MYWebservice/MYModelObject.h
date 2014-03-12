//
//  MYModelObject.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MYModelObject : NSManagedObject

+ (id)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;
+ (NSDateFormatter*)dateFormatter;
@end
