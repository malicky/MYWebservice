//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import "UIImageView+Network.h"
#import <objc/runtime.h>

static char URL_KEY;


@implementation UIImageView(Network)

@dynamic imageURL;

// Use this NSCache singleton
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
	
    // Already cached
	NSData *cachedData = [[self imageCache] objectForKey:key];
	if (cachedData) {
        self.imageURL   = nil;
        [self loadFromData:cachedData];
        return;
	}
    
    // image not in cached
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
                [[self imageCache] setObject:data forKey:key]; // cache
                [self loadFromData:data];
            }
        }
		self.imageURL = nil;
	});
}

// set the image and dimensions
- (void)loadFromData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage imageWithData:data];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height);
    });
}

- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}
- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}

@end
