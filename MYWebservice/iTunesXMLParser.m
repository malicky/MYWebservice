/*
     File: iTunesXMLParser.m
*/

#import "iTunesXMLParser.h"
#import "Song.h"


@interface iTunesXMLParser ()

@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) NSMutableDictionary *currentSong;
@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic, copy) NSString *currentLinkAudio;
@property (nonatomic, copy) NSString *currentSongIdentifier;
@property (nonatomic, strong) NSDateFormatter *parseFormatter;

@end

@implementation iTunesXMLParser {
    BOOL _storingCharacters;
    NSUInteger _kCountForNotification;
    parseCompletionHandler _callback;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // for itunes
        _parseFormatter = [[NSDateFormatter alloc] init];
        [_parseFormatter setDateStyle:NSDateFormatterLongStyle];
        [_parseFormatter setTimeStyle:NSDateFormatterNoStyle];
        [_parseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    }
    return self;
}
- (NSArray *)parseData:(NSMutableData *)data {
    self.songs = [NSMutableArray array];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    self.currentString = [NSMutableString string];
    BOOL result = [parser parse];
    if (result) {
        return self.songs;
    }
    
    return nil;
}

- (NSMutableArray *)parseData:(NSMutableData *)data
              batchItemsCount:(NSUInteger)count
          withCompletionBlock:(parseCompletionHandler)completionBlock {
    
    _kCountForNotification = count;
    completionBlock = [completionBlock copy];
    
    self.songs = [NSMutableArray array];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    self.currentString = [NSMutableString string];
    BOOL result = [parser parse];
    if (result) {
        return self.songs;
    }
    
    return nil;
}

#pragma mark Parsing support methods


- (void)finishedCurrentSong {
    
    [self addCurrentSong];
    
    if ([self.songs count] % _kCountForNotification == 0 && _callback) {
        _callback ([self.songs copy]);
        [self.songs removeAllObjects];
    }
    self.currentSong = nil;
}

- (void)addCurrentSong {
    if (self.currentSong) {
        self.currentSong[kElementName_LinkAudio] = [self.currentLinkAudio copy];
        self.currentSong[kElementName_Id] = [self.currentSongIdentifier copy];
        [self.songs addObject:self.currentSong];
    }
}
#pragma mark NSXMLParser Parsing Callbacks

// Constants for the XML element names that will be considered during the parse. 
// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.
//
static NSString *kElementName_Entry = @"entry";
static NSString *kElementName_Title = @"title";
static NSString *kElementName_LinkImage = @"im:image";
static NSString *kElementName_LinkAudio = @"link";
static NSString *kElementName_Id = @"id";


static NSString *kAttributeName_Type = @"type";
static NSString *kAttributeName_TypeAudio = @"audio/x-m4a";
static NSString *kAttributeName_Href = @"href";
static NSString *kAttributeName_inId = @"im:id";

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqualToString:kElementName_Entry]) {
        self.currentSong = [NSMutableDictionary dictionary];
    } else if ([elementName isEqualToString:kElementName_Title] ||
               [elementName isEqualToString:kElementName_LinkImage]
               ) {
        [self.currentString setString:@""];
        _storingCharacters = YES;
        
    } else if ([elementName isEqualToString:kElementName_LinkAudio]) {
        if (attributeDict[kAttributeName_Type] && [attributeDict[kAttributeName_Type]  isEqualToString:kAttributeName_TypeAudio]){
            NSLog(@"href = %@", attributeDict[kAttributeName_Href]);
            self.currentLinkAudio = attributeDict[kAttributeName_Href];
        }
    } else if ([elementName isEqualToString:kElementName_Id]) {
        if (attributeDict[kAttributeName_inId]){
            NSLog(@"id = %@", attributeDict[kAttributeName_inId]);
            self.currentSongIdentifier = attributeDict[kAttributeName_inId];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kElementName_Entry]) {
        [self finishedCurrentSong];
    } else if ([elementName isEqualToString:kElementName_Title]) {
        self.currentSong[kElementName_Title] = [self.currentString copy];
    } else if ([elementName isEqualToString:kElementName_LinkImage]) {
        self.currentSong[kElementName_LinkImage] = [self.currentString copy];
    }
    _storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_storingCharacters) {
        [self.currentString appendString:string];
        NSLog(@"self.currentString = %@", self.currentString);
    }
}

/*
 A production application should include robust error handling as part of its parsing implementation.
 The specifics of how errors are handled depends on the application.
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
}

@end
