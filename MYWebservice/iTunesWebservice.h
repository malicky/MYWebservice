//
//  iTunesWebservice.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iTunesWebservice : NSObject <NSXMLParserDelegate>

- (void)fetchAll:(void (^)(NSArray* records))callback;

@end
