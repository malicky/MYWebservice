//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//  Adapted by me to use an NSCache etc...
//

#import "UIImageView+Network.h"
#import <objc/runtime.h>

static char URL_KEY;


@implementation UIImageView(Network)

@dynamic imageURL;

/**
 *  Image cache Singleton
 *
 *  @return return the single instance of NSCache
 */
- (NSCache *)imageCache {
    static NSCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!imageCache) {
            imageCache = [[NSCache alloc]init];
        }
    });
    
    return imageCache;
}

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder
               cachingKey:(NSString*)key {
    
    self.imageURL = url;
	self.image = placeholder;
	
    // Already in the cache
	NSData *cachedData = [[self imageCache] objectForKey:key];
	if (cachedData) {
        self.imageURL   = nil;
        
        [self loadFromData:cachedData];
        return;
	}
    
    // Not yet cached, use a background queue to download
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
                [[self imageCache] setObject:data forKey:key]; // save to cache
                
                [self loadFromData:data];
            }
        }
		self.imageURL = nil;
	});
}

// set the image and dimensions
/**
 *  Set the image property and the default dimension of self
 *
 *  @param data NSData from the UIImage
 */
- (void)loadFromData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage imageWithData:data];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height);
    });
}

/**
 *  <#Description#>
 *
 *  @param newImageURL set/get the image url as associated object
 */
- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}
- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}

@end
