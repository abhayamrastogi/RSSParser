
#import "FeedItemViewModel.h"
#import "Feed.h"
#import "ImageDownloader.h"
#import "Utility.h"

#define kTitleHeight 21
#define kDescriptionHeight 18

@interface FeedItemViewModel()

// the set of ImageDownloader object for each row
@property (strong, nonatomic) ImageDownloader *imageDownloader;

@end

@implementation FeedItemViewModel

#pragma mark - Initialiation
- (instancetype)initWithFeed:(Feed *)feed{
    
    self = [super init];
    if (!self) return nil;
    
    _feed = feed;
    
    return self;
}

#pragma mark - getter methods
-(NSString *)titleLabelText{
    return _feed.title;
}

-(NSAttributedString *)descriptionLabelText{
    return [[NSAttributedString alloc] initWithData:[_feed.feedDescription dataUsingEncoding:NSUTF8StringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                 documentAttributes:nil error:nil];
}

-(NSString *)dateLabelText{
    return _feed.pubDate;
}

-(NSString *)link{
    return _feed.link;
}

-(NSString *)imageURL{
    return _feed.mediaContent.url;
}

-(UIImage *)image{
    return _feed.mediaContent.image;
}

-(CGSize)imageSize{
    return CGSizeMake(_feed.mediaContent.width, _feed.mediaContent.height);
}

-(CGFloat)titleLabelHeight{
    return kTitleHeight;
}

-(CGFloat)descriptionLabelHeight{
    return kDescriptionHeight*2;
}

-(CGFloat)imageAspectRatio{
    return _feed.mediaContent.width/_feed.mediaContent.height;
}

+(UIFont *)titleLabelFont{
    return [UIFont systemFontOfSize:17];
}

+(UIFont *)descriptionLabelFont{
    return [UIFont systemFontOfSize:15];
}

// -------------------------------------------------------------------------------
//    startDownload:completion:
// -------------------------------------------------------------------------------
- (void)startDownload:(FeedItemImageHandler _Nullable )completion{
    
    if (_imageDownloader == nil){
        _imageDownloader = [[ImageDownloader alloc] init];
        _imageDownloader.feed = _feed;
        
        __weak typeof(self) weakSelf = self;
        [_imageDownloader setCompletionHandler:^{
            completion(weakSelf.feed.mediaContent.image,nil);
            weakSelf.imageDownloader  = nil;
        }];
        
        [_imageDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//    cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload{
    [_imageDownloader cancelDownload];
    _imageDownloader = nil;
}

@end
