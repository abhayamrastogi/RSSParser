
#import <UIKit/UIKit.h>

@protocol EmptyStateViewDelegate<NSObject>
-(void)emptyStateViewRefreshButtonPressed:(UIView *_Nullable)view;
@end

@interface EmptyStateView : UIView
@property (nonatomic, weak, nullable) id<EmptyStateViewDelegate> delegate;
@property (nonatomic) UILabel * _Nonnull lTitleLabel;
@property (nonatomic) UIButton * _Nonnull bButtonRefresh;

@end
