//
//  MYWebservice.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYWebservice : NSObject

- (void)fetchAll:(void (^)(NSArray* records))callback;

@end
