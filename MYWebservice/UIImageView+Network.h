//
//  UIImage+Network.h
//  Fireside
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView(Network)

@property (nonatomic, copy) NSURL *imageURL;

/**
 *  Asynchronously download the image at url, with in-memory caching
 *
 *  @param url         url location of the image to download
 *  @param placeholder placeholder image to be used when downloading.
 *  @param key         key for retrieving from the cache.
 */
- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder
               cachingKey:(NSString*)key;

@end
