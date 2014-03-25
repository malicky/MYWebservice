/*
     File: iTunesXMLParser.h
 */

#import <UIKit/UIKit.h>

@class Song;

@interface iTunesXMLParser : NSObject <NSXMLParserDelegate>

- (instancetype)init;
- (NSArray *)parseData:(NSData *)data;
- (NSMutableArray *)parseData:(NSData *)data batch:(NSUInteger)count callback:(void (^)(NSMutableArray* records))callback;
@end
