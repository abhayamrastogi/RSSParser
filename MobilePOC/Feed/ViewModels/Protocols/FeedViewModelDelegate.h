
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FeedViewModel;

@protocol FeedViewModelDelegate

- (void)feedViewModel:(FeedViewModel *)viewModel fetchedFeeds:(NSArray *)feeds;
- (void)feedViewModel:(FeedViewModel *)viewModel failedToFetchFeedsWithError:(NSError *)error;
- (void)feedViewModel:(FeedViewModel *)viewModel didFailWithNetworkError:(NSError *)error;

@end

