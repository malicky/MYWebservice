/*
     File: iTunesXMLParser.h
 */

#import <UIKit/UIKit.h>


typedef void(^parseCompletionHandler) (NSMutableArray *records);

@class YMSong;

@interface YMiTunesXMLParser : NSObject <NSXMLParserDelegate>
- (instancetype)init;
- (NSArray *)parseData:(NSData *)data;
- (NSMutableArray *)parseData:(NSData *)data
               batchItemsCount:(NSUInteger)count
          withCompletionBlock:(parseCompletionHandler)completionBlock;
@end
