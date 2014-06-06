

#import "MyScrollView.h"


@implementation MyScrollView
/**
 *  Center the cover view
 */
-(void)layoutSubviews {
    [super layoutSubviews];
    
    // get the cover view
    UIView* coverView = [self.delegate viewForZoomingInScrollView:self];
    CGFloat coverViewWidth = coverView.frame.size.width;
    CGFloat coverViewHeigth = coverView.frame.size.height;
    
    CGFloat svw = self.bounds.size.width;
    CGFloat svh = self.bounds.size.height;
    
    CGRect f = coverView.frame;
    if (coverViewWidth < svw)
        f.origin.x = (svw - coverViewWidth) / 2.0;
    else
        f.origin.x = 0;
    
    if (coverViewHeigth < svh)
        f.origin.y = (svh - coverViewHeigth) / 2.0;
    else
        f.origin.y = 0;
    
    coverView.frame = f;
}
@end
