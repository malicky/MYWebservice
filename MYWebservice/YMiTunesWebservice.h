//
//  iTunesWebservice.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^webServiceCompletionHandler) (NSMutableArray *records);

@interface YMiTunesWebservice : NSObject

- (void)fetchAtURL:(NSURL *)url withCompletionBlock:(webServiceCompletionHandler)completionBlock;

@end
