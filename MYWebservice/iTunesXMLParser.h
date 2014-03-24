/*
     File: iTunesXMLParser.h
 */

#import <UIKit/UIKit.h>

@class Song;

@interface iTunesXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSDateFormatter *parseFormatter;

- (NSArray *)parseData:(NSData *)data;
- (NSMutableArray *)parseData:(NSData *)data batch:(NSUInteger)count callback:(void (^)(NSMutableArray* records))callback;


@end
