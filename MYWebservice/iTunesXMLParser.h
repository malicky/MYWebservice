/*
     File: iTunesXMLParser.h
 */

#import <UIKit/UIKit.h>


typedef void(^parseCompletionHandler) (NSMutableArray *records);

@class Song;

@interface iTunesXMLParser : NSObject <NSXMLParserDelegate>

- (instancetype)init;
- (NSArray *)parseData:(NSData *)data;
- (NSMutableArray *)parseData:(NSData *)data
               batchItemsCount:(NSUInteger)count
          withCompletionBlock:(parseCompletionHandler)completionBlock;
@end
