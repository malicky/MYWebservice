//
//  MYImporter.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMiTunesWebservice, YMPersistence;

@interface YMImporter : NSObject

/**
 *  Initialize the importer with the context to save in and the webservice to request
 */- (id)initWithParentContext:(NSManagedObjectContext *)context webservice:(YMiTunesWebservice *)webservice;
- (void)import;

@end
