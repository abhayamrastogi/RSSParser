
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Feed;

// A block to call when an image download/failed completed.
typedef void (^FeedItemImageHandler)(UIImage * _Nullable image, NSError * _Nullable error);

@interface FeedItemViewModel : NSObject
@property (strong, nonatomic) Feed * _Nonnull feed;
@property (strong, nonatomic)NSString * _Nullable titleLabelText;
@property (strong, nonatomic)NSAttributedString * _Nullable descriptionLabelText;
@property (strong, nonatomic)NSString * _Nullable imageURL;
@property (strong, nonatomic)NSString * _Nullable dateLabelText;
@property (strong, nonatomic)NSString * _Nullable link;
@property (strong, nonatomic)UIImage * _Nullable image;

// Utility methods
+(UIFont *_Nullable)titleLabelFont;
+(UIFont *_Nullable)descriptionLabelFont;
-(CGSize)imageSize;
-(CGFloat)imageAspectRatio;
-(CGFloat)titleLabelHeight;
-(CGFloat)descriptionLabelHeight;

// The initializer for this FeedItemViewModel.
- (instancetype _Nonnull )initWithFeed:(Feed *_Nonnull)feed;

// Instance method to start download image operation
- (void)startDownload:(FeedItemImageHandler _Nullable )completion;

// cancel download image operation
- (void)cancelDownload;
@end
