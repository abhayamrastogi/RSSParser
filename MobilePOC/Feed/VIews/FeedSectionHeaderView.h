
#import <UIKit/UIKit.h>

@class FeedItemViewModel;

@interface FeedSectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIView *vBaseView;
@property (nonatomic, strong) UILabel *lTitleLabel;
@property (nonatomic, strong) UILabel *lDescriptionLabel;
@property (nonatomic, strong) UIImageView *ivImageView;

// class method to register view as supplementary view for collection view
+(void)registerSupplementaryViewForCollectionView:(UICollectionView *)collectionView;

// The initializer for this FeedSectionHeaderView.
- (instancetype)initWithFrame:(CGRect)aRect;
- (instancetype)initWithCoder:(NSCoder*)coder;

// Configure view with feed item view  model.
- (void)configureView:(FeedItemViewModel *)feedItemViewModel;
@end
