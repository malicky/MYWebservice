//
//  iTunesWebservice.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMiTunesWebservice.h"
#import "YMiTunesXMLParser.h"
#import "YMSong.h"

const unsigned int kPageRecordsCount = 10; //

@implementation YMiTunesWebservice {
}

// fetch the xml from the webservice api
// TODO: code refactoring
- (void)fetchAtURL:(NSURL *)url withCompletionBlock:(webServiceCompletionHandler)completionBlock {
   
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     if(error) {
                                         NSLog(@"error: %@", error.localizedDescription);
                                         completionBlock(nil);
                                         return ;
                                     }
                                     // in case of succes, start a background queue for parsing
                                     dispatch_queue_t parserQueue = dispatch_queue_create("parserQueue", NULL);
                                     dispatch_async(parserQueue, ^{
                                         YMiTunesXMLParser *parser = [[YMiTunesXMLParser alloc] init];
                                         
                                         // parse by pages of kPageRecordsCount records for UI responsivness.
                                         NSMutableArray * result = [parser parseData:data batchItemsCount:kPageRecordsCount
                                                                 withCompletionBlock:completionBlock];
                                         if (result && ( [result count] > 0 ) && completionBlock) {
                                             completionBlock (result);
                                         }
                                     });
      }] resume ];
}

@end
