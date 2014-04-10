//
//  iTunesWebservice.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "iTunesWebservice.h"
#import "iTunesXMLParser.h"
#import "Song.h"

const unsigned int kBatchRecordsCount = 10;

@implementation iTunesWebservice {
}

- (void)fetchAllWithCompletionBlock:(webServiceCompletionHandler)completionBlock {
    
     NSString *urlString = @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=400/xml";
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     if(error) {
                                         NSLog(@"error: %@", error.localizedDescription);
                                         completionBlock(nil);
                                         return ;
                                     }
                                     dispatch_queue_t parserQueue = dispatch_queue_create("parserQueue", NULL);
                                     dispatch_async(parserQueue, ^{
                                         iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
                                         NSMutableArray * result = [parser parseData:data batchItemsCount:kBatchRecordsCount
                                                                 withCompletionBlock:completionBlock];
                                         if (result && ( [result count] > 0 ) && completionBlock) {
                                             completionBlock (result);
                                         }
                                     });
      }] resume ];
}

@end
