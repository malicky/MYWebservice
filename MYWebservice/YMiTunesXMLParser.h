/*
     File: iTunesXMLParser.h
 */

#import <UIKit/UIKit.h>


typedef void(^parseCompletionHandler) (NSMutableArray *records);

@class YMSong;

@interface YMiTunesXMLParser : NSObject <NSXMLParserDelegate>

- (instancetype)init;
- (NSArray *)parseData:(NSData *)data;


/**
 *  Parse by chunk of batchItemsCount, then save the songs in core data
 *
 *  @param data            NSDATA of xml
 *  @param count           nombre of parsed items before importing (between 10 to 20)
 *  @param completionBlock block to be called at completion of the parse 
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)parseData:(NSData *)data
               batchItemsCount:(NSUInteger)count
          withCompletionBlock:(parseCompletionHandler)completionBlock;
@end
