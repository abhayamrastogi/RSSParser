
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MediaContent.h"

@interface Feed : NSObject
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *link;
@property (strong, nonatomic)NSString *feedDescription;
@property (strong, nonatomic)NSString *pubDate;
@property (strong, nonatomic)MediaContent *mediaContent;
@end
