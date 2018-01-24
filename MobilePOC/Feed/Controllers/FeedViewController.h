
#import <UIKit/UIKit.h>

@class FeedViewModel;
@interface FeedViewController : UICollectionViewController
@property (nonatomic) FeedViewModel *viewModel;
- (instancetype)initWithViewModel:(FeedViewModel *)viewModel;
@end
