
#import <Foundation/Foundation.h>

@class Feed;

@interface ImageDownloader : NSObject
@property (nonatomic, strong) Feed *feed;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;
@end
