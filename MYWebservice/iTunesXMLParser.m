/*
     File: iTunesXMLParser.m
*/

#import "iTunesXMLParser.h"
#import "Song.h"


@interface iTunesXMLParser ()

@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) NSMutableDictionary *currentSong;
@property (nonatomic, strong) NSMutableData *xmlData;

@end

@implementation iTunesXMLParser {
    BOOL _storingCharacters;
    NSMutableArray *_songs;
    
}

//@synthesize currentString, currentSong, parseFormatter, xmlData;


#pragma mark NSURLConnection Delegate methods

/*
 Disable caching so that each time we run this app we are starting with a clean slate.
 You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}


// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Append the downloaded chunk of data.
    [_xmlData appendData:data];
}

- (NSArray *)parseData:(NSMutableData *)data {
    _songs = [NSMutableArray array];
    self.xmlData = data;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    self.currentString = [NSMutableString string];
    BOOL result = [parser parse];
    if (result) {
        return _songs;
    }
    
    return nil;
}


#pragma mark Parsing support methods


- (void)finishedCurrentSong {
    
    [_songs addObject:self.currentSong];
    
    self.currentSong = nil;
}


#pragma mark NSXMLParser Parsing Callbacks

// Constants for the XML element names that will be considered during the parse. 
// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.
//
static NSString *kName_Item = @"item";
static NSString *kName_Title = @"title";
static NSString *kName_Category = @"category";
static NSString *kName_Artist = @"itms:artist";
static NSString *kName_Album = @"itms:album";
static NSString *kName_ReleaseDate = @"itms:releasedate";

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kName_Item]) {
        self.currentSong = [NSMutableDictionary dictionary];
    } else if ([elementName isEqualToString:kName_Title] || [elementName isEqualToString:kName_Category] || [elementName isEqualToString:kName_Artist] || [elementName isEqualToString:kName_Album] || [elementName isEqualToString:kName_ReleaseDate]) {
        [_currentString setString:@""];
        _storingCharacters = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:kName_Item]) {
        [self finishedCurrentSong];
    } else if ([elementName isEqualToString:kName_Title]) {
        self.currentSong[@"title"] = [self.currentString copy];
    } else if ([elementName isEqualToString:kName_Category]) {
        self.currentSong[@"category"] = [self.currentString copy];
    } else if ([elementName isEqualToString:kName_Artist]) {
        self.currentSong[@"artiste"] = [self.currentString copy];
    } else if ([elementName isEqualToString:kName_Album]) {
        self.currentSong[@"album"] = [self.currentString copy];
    } else if ([elementName isEqualToString:kName_ReleaseDate]) {
        self.currentSong[@"releaseDate"] = [self.parseFormatter dateFromString:[self.currentString copy]];
    }
    _storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_storingCharacters) [_currentString appendString:string];
    NSLog(@"self.currentString = %@", self.currentString);

}

/*
 A production application should include robust error handling as part of its parsing implementation.
 The specifics of how errors are handled depends on the application.
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
}

@end
