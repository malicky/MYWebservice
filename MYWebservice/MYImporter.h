//
//  MYImporter.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYWebservice;

@interface MYImporter : NSObject
- (id)initWithContext:(NSManagedObjectContext *)context webservice:(MYWebservice *)webservice;
- (void)import;
@end
