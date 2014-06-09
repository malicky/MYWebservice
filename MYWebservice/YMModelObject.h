//
//  MYModelObject.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface YMModelObject : NSManagedObject

/**
 *  convenience method
 *
 *  @return entity name of our managed object.
 */
+ (id)entityName;

/**
 *  create a new managed object in the managed object context
 *
 *  @param context moc use to insert the new object
 *
 *  @return the new instance the managed object.
 */
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end
