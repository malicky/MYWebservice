/*
     File: iTunesXMLParser.m
*/

#import "YMiTunesXMLParser.h"
#import "YMSong.h"

#define debug 1

@interface YMiTunesXMLParser ()

@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) NSMutableDictionary *currentSong;
@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic, copy) NSString *currentLinkAudio;
@property (nonatomic, copy) NSString *currentSongIdentifier;


@property (nonatomic, strong) NSDateFormatter *parseFormatter;
@property (nonatomic) BOOL storingCharacters;
@property (nonatomic) NSUInteger kCountForNotification;
@property (nonatomic, copy) parseCompletionHandler callback;;
@end

@implementation YMiTunesXMLParser {
    /**
     *  Parsing the location of medium image of the cover
     */
    BOOL _fImageMediumLocationFound;
    /**
     *  Parsing the location of the big image of the cover
     */
    BOOL _fImageBigLocationFound;
    /**
     *  location of the medium image (60x60)
     */
    NSString *_currentSongImageMediumLocation;
    /**
     *  location of the big image (170x170)
     */
    NSString *_currentSongImageBigLocation;

}

/**
 *  Description
 *
 *  @return return value description
 */
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

/**
 *  Parse the passed data
 *
 *  @param NSData to be parsed
 *
 *  @return an array of songs objects if success, nil otherwise
 */
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

/**
 *  Parse a chunk of the passe data
 *
 *  @param data            NSData to be parsed
 *  @param count           number of songs before passing to the importer
 *  @param completionBlock <#completionBlock description#>
 *
 *  @return an array of songs objects if success, nil otherwise
 */
- (NSMutableArray *)parseData:(NSMutableData *)data
              batchItemsCount:(NSUInteger)count
          withCompletionBlock:(parseCompletionHandler)completionBlock {
    
    self.kCountForNotification = count;
    self.callback = [completionBlock copy];
    
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
/**
 *  Called when a new song has been saved
 */
- (void)finishedCurrentSong {
    [self addCurrentSong];
    
    // check that the parsed number of songs against kCountForNotification
    if ([self.songs count] % self.kCountForNotification == 0 && self.callback) {
        // send to callback to save the songs
        self.callback ([self.songs copy]);
        
        // cleanup
        [self.songs removeAllObjects];
    }
    
    // reset
    self.currentSong = nil;
}

/**
 *  accumulate the parsed songs in self.songs
 */
- (void)addCurrentSong {
    if (self.currentSong) {
        self.currentSong[kElementName_LinkAudio] = [self.currentLinkAudio copy];
        self.currentSong[kElementName_Id] = [self.currentSongIdentifier copy];
        
        self.currentSong[@"imageMedium"] = _currentSongImageMediumLocation;
        self.currentSong[@"imageBig"] = _currentSongImageBigLocation;
        
        if (debug == 1) {
            NSLog(@"_currentSongImageMediumLocation = %@", _currentSongImageMediumLocation);
            NSLog(@"_currentSongImageBigLocation = %@", _currentSongImageBigLocation);

        }
        
        [self.songs addObject:self.currentSong];
    }
}
#pragma mark NSXMLParser Parsing Callbacks

// Constants for the XML element names that will be considered during the parse. 
// Declaring these as static constants reduces the number of objects created during the run
//
static NSString *kElementName_Entry = @"entry";
static NSString *kElementName_Title = @"title";
static NSString *kElementName_LinkImage = @"im:image";
static NSString *kElementName_LinkAudio = @"link";
static NSString *kElementName_Id = @"id";
static NSString *kElementName_NS_Artist = @"im:artist";
static NSString *kElementName_Artist = @"artist";

static NSString *kAttributeName_Type = @"type";
static NSString *kAttributeName_TypeAudio = @"audio/x-m4a";
static NSString *kAttributeName_Href = @"href";
static NSString *kAttributeName_imId = @"im:id";
static NSString *kAttributeValue_height_medium = @"60";
static NSString *kAttributeValue_height_big = @"170";

static NSString *kAttributeName_height = @"height";

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqualToString:kElementName_Entry]) {
        self.currentSong = [NSMutableDictionary dictionary];
    } else if ([elementName isEqualToString:kElementName_Title] ||
               [elementName isEqualToString:kElementName_LinkImage] ||
               [elementName isEqualToString:kElementName_LinkAudio] ||
               [elementName isEqualToString:kElementName_NS_Artist] ||
               [elementName isEqualToString:kElementName_Id]
               ) {
        [self.currentString setString:@""];
        self.storingCharacters = YES;
        
    }
    if ([elementName isEqualToString:kElementName_LinkAudio]) {
        if (attributeDict[kAttributeName_Type] && [attributeDict[kAttributeName_Type]  isEqualToString:kAttributeName_TypeAudio]){
            if (debug == 1) {
                NSLog(@"href = %@", attributeDict[kAttributeName_Href]);
            }
            self.currentLinkAudio = attributeDict[kAttributeName_Href];
        }
    } else if ([elementName isEqualToString:kElementName_Id]) {
        if (attributeDict[kAttributeName_imId]){
            if (debug == 1) {
                NSLog(@"id = %@", attributeDict[kAttributeName_imId]);
            }
            self.currentSongIdentifier = attributeDict[kAttributeName_imId];
        }
    } else if ([elementName isEqualToString:kElementName_LinkImage]) {
        if ([attributeDict[kAttributeName_height]isEqualToString:kAttributeValue_height_medium]) {
            _fImageMediumLocationFound = YES;
            _currentSongImageMediumLocation = @"";
        } else if ([attributeDict[kAttributeName_height]isEqualToString:kAttributeValue_height_big]) {
            _fImageBigLocationFound = YES;
            _currentSongImageBigLocation = @"";
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kElementName_Entry]) {
        [self finishedCurrentSong];
    } else if ([elementName isEqualToString:kElementName_Title]) {
        self.currentSong[kElementName_Title] = [self.currentString copy];
    } else if ([elementName isEqualToString:kElementName_LinkImage]) {
        self.currentSong[kElementName_LinkImage] = [self.currentString copy];
    } else if ([elementName isEqualToString:kElementName_NS_Artist]) {
            self.currentSong[kElementName_Artist] = [self.currentString copy];
    }
    self.storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.storingCharacters) {
        [self.currentString appendString:string];
        
        if (_fImageMediumLocationFound) {
            _currentSongImageMediumLocation = [self.currentString copy];
            _fImageMediumLocationFound = NO;
        }
        if (_fImageBigLocationFound) {
            _currentSongImageBigLocation = [self.currentString copy];
            _fImageBigLocationFound = NO;
        }
        if (debug == 1) {
            NSLog(@"self.currentString = %@", self.currentString);
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
    if (debug==1) {
        NSString *message = [NSString stringWithFormat:@"Error %li Description: %@, Line: %li, Column: %li", (long)[parseError code],
         [[parser parserError] localizedDescription], (long)[parser lineNumber],
         (long)[parser columnNumber]];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Parsing error", nil)
                                                         message:NSLocalizedString(message, nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
        [alert show];
        NSLog(@"parser error:\n%@", message);
    }
}

@end
