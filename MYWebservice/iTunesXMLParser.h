/*
     File: iTunesXMLParser.h
 */

#import <UIKit/UIKit.h>

@class Song;

@interface iTunesXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSDateFormatter *parseFormatter;

- (NSArray *)parseData:(NSData *)data;

@end
