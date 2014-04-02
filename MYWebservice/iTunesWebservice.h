//
//  iTunesWebservice.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^webServiceCompletionHandler) (NSMutableArray *records);

@interface iTunesWebservice : NSObject

- (void)fetchAllWithCompletionBlock:(webServiceCompletionHandler)completionBlock;

@end
