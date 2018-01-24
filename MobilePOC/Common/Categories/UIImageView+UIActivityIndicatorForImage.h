
#import <UIKit/UIKit.h>

@interface UIImageView (UIActivityIndicatorForImage)
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end
