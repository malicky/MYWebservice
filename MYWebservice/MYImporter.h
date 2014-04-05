//
//  MYImporter.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class iTunesWebservice, PersistantStack;

@interface MYImporter : NSObject
//- (id)initWithContext:(NSManagedObjectContext *)context webservice:(iTunesWebservice *)webservice;
- (id)initWithParentContext:(NSManagedObjectContext *)context webservice:(iTunesWebservice *)webservice;
- (void)import;
@end
