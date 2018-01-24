
#import "UIImageView+UIActivityIndicatorForImage.h"
#import <objc/runtime.h>
#import "Utility.h"

static char activityIndicatorAssociationKey;

@interface UIImageView (Private)
@end

@implementation UIImageView (UIActivityIndicatorForImage)

@dynamic activityIndicator;

- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &activityIndicatorAssociationKey);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &activityIndicatorAssociationKey, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)showActivityIndicator{
    
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped = YES;
        self.activityIndicator.userInteractionEnabled = FALSE;
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self addSubview:self.activityIndicator];
            [self.activityIndicator startAnimating];
            [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:FALSE];
            CENTER_VIEW(self, self.activityIndicator);
        }];
    }else{
        [self.activityIndicator startAnimating];
    }
}

- (void)hideActivityIndicator{
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.activityIndicator stopAnimating];
    }];
}

@end
