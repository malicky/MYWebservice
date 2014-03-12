//
//  MYWebservice.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYWebservice.h"
#import "MYAppDelegate.h"

@implementation MYWebservice

- (void)fetchAll:(void (^)(NSArray* records))callback {
    NSString *urlString = @"http://vimeo.com/api/v2/album/58/videos.json?page=1";
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     if(error) {
                                         NSLog(@"error: %@", error.localizedDescription);
                                         callback(nil);
                                         return ;
                                     }
                                     NSError *jsonError = nil;
                                     id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                     if ([result isKindOfClass:[NSArray class]]) {
                                         callback (result);
                                     }
                
      }] resume ];
}


@end
