
#import <UIKit/UIKit.h>
@class FeedItemViewModel;

@interface FeedCell : UICollectionViewCell
@property (nonatomic, strong) UIView *vBaseView;
@property (nonatomic, strong) UILabel *lTitleLabel;
@property (nonatomic, strong) UIImageView *ivImageView;
+(void)registerCellForCollectionView:(UICollectionView *)collectionView;
-(void)configureCellWithViewModel:(FeedItemViewModel *)feedItemViewModel;
@end
