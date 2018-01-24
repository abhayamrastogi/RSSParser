
#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "Feed.h"
#import "Utility.h"

@interface ImageDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation ImageDownloader

// -------------------------------------------------------------------------------
//    startDownload
// -------------------------------------------------------------------------------
- (void)startDownload{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.feed.mediaContent.url]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       if (error != nil){
                                                           
                                                       }
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           
                                                           // Set image and clear temporary data/image
                                                           UIImage *image = [[UIImage alloc] initWithData:data];
                                                           
                                                           if (image.size.width != kImageSize || image.size.height != kImageSize){
                                                               CGSize itemSize = CGSizeMake(kImageSize, kImageSize);
                                                               UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                                                               CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                                               [image drawInRect:imageRect];
                                                               self.feed.mediaContent.image = UIGraphicsGetImageFromCurrentImageContext();
                                                               UIGraphicsEndImageContext();
                                                           }else{
                                                               self.feed.mediaContent.image = image;
                                                           }
                                                           
                                                           // call our completion handler to tell our client that our image is ready for display
                                                           if (self.completionHandler != nil) {
                                                               self.completionHandler();
                                                           }
                                                       }];
                                                   }];
    
    [self.sessionTask resume];
}

// -------------------------------------------------------------------------------
//    cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end
