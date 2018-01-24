
#import "UIView+Helpers.h"

@implementation UIView (Helpers)

- (BOOL)sendAction:(SEL)action from:(id)sender{
    // Get the target in the responder chain
    id target = sender;
    
    while (target && ![target canPerformAction:action withSender:sender]) {
        target = [target nextResponder];
    }
    
    if (!target)
        return NO;
    
    return [[UIApplication sharedApplication] sendAction:action to:target from:sender forEvent:nil];
}

@end
