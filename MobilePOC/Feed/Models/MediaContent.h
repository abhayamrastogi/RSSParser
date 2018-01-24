
#import <UIKit/UIKit.h>

@interface MediaContent : NSObject

@property (strong, nonatomic)NSString *url;
@property (nonatomic)float width;
@property (nonatomic)float height;
@property (strong, nonatomic)UIImage *image;
@end
