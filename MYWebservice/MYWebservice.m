//
//  MYWebservice.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYWebservice.h"
#import "MYAppDelegate.h"

#import "Song.h"

@interface MYWebservice ()
@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) NSMutableDictionary *currentSong;
@property (nonatomic, strong) NSDateFormatter *parseFormatter;
@property (nonatomic, strong) NSMutableArray *songs;

@end

@implementation MYWebservice {
    BOOL _storingCharacters;
}

- (void)fetchAll:(void (^)(NSArray* records))callback {
    
    self.parseFormatter = [[NSDateFormatter alloc] init];
    [self.parseFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.parseFormatter setTimeStyle:NSDateFormatterNoStyle];
    // necessary because iTunes RSS feed is not localized, so if the device region has been set to other than US
    // the date formatter must be set to US locale in order to parse the dates
    [self.parseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    self.songs = [NSMutableArray array];

    NSString *urlString = @"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=300/rss.xml";
    NSURL *url = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     if(error) {
                                         NSLog(@"error: %@", error.localizedDescription);
                                         callback(nil);
                                         return ;
                                     }
                                     dispatch_queue_t parserQueue = dispatch_queue_create("parserQueue", NULL);
                                     dispatch_async(parserQueue, ^{
                                         NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                                         parser.delegate = self;
                                         self.currentString = [NSMutableString string];
                                         BOOL success = [parser parse];
                                         if (success) {
                                             NSLog(@"No errors");
                                             NSLog(@"%@", self.songs);
                                         } else {
                                             NSLog(@"Error");
                                         }




                                     });
//
//                                     NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
//                                     parser.delegate = self;
//                                     self.currentString = [NSMutableString string];
//                                     [parser parse];
////
//                                     NSError *jsonError = nil;
//                                     id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//                                     if ([result isKindOfClass:[NSArray class]]) {
//                                         callback (result);
//                                     }
                
      }] resume ];
}

#pragma mark NSXMLParser Parsing Callbacks
- (void)finishedCurrentSong {
    
    [self.songs addObject:self.currentSong];
    self.currentSong = nil;
}
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
        [self.currentString setString:@""];
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
    if (_storingCharacters) [self.currentString appendString:string];
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
