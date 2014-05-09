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
- (id)initWithParentContext:(NSManagedObjectContext *)context webservice:(YMiTunesWebservice *)webservice;
- (void)import;
@end