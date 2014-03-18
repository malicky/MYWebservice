//
//  MYModelObject.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYModelObject.h"

@implementation MYModelObject

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

+ (id)entityName {
    return NSStringFromClass(self);
}

+ (NSDateFormatter*)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return dateFormatter;
}
@end