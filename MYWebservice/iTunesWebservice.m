//
//  iTunesWebservice.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "iTunesWebservice.h"
#import "MYAppDelegate.h"
#import "iTunesXMLParser.h"
#import "Song.h"

const unsigned int kBatchRecordsCount = 10;
@interface iTunesWebservice ()

@end

@implementation iTunesWebservice {
    BOOL _storingCharacters;
}

- (void)fetchAll:(void (^)(NSMutableArray* records))callback {
    
     NSString *urlString = @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=99/xml";
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     if(error) {
                                         NSLog(@"error: %@", error.localizedDescription);
                                         callback(nil);
                                         return ;
                                     }
                                     dispatch_queue_t parserQueue = dispatch_queue_create("parserQueue", NULL);
                                     dispatch_async(parserQueue, ^{
                                         iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
                                         NSMutableArray * result = [parser parseData:data batch:kBatchRecordsCount callback:callback];
                                         if (result && ( [result count] > 0 ) && callback) {
                                             callback (result);
                                         }
                                     });
      }] resume ];
}

@end
