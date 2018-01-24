
#import <Foundation/Foundation.h>
#import "FeedViewModelDelegate.h"

@class FeedItemViewModel;

@interface FeedViewModel : NSObject

//delegate to communicate with feed controller
@property (nonatomic, weak, nullable) id<FeedViewModelDelegate> delegate;
@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSMutableArray * _Nullable feedItemViewModels;

-(UIEdgeInsets)collectionViewSectionInset;
-(NSInteger)collectionViewMinimumLineSpacing;
-(NSInteger)collectionViewMinimumInterItemSpacing;

// Instance method to fetch latest rss feeds.
-(void)fetchFeeds;

//Returns feedItemViewModel for corresponding index path
-(FeedItemViewModel *_Nonnull)itemViewModelForIndexPath:(NSIndexPath *_Nonnull)indexPath;

//Returns feedItemViewModel for corresponding section
-(FeedItemViewModel *_Nonnull)itemViewModelForSection:(NSInteger)section;

//Returns size for corresponding index path
-(CGSize)sizeForItemAtIndexPath:(NSIndexPath *_Nonnull)indexPath;

//Returns size for corresponding section
-(CGSize)referenceSizeForHeaderInSection:(NSInteger)section;

@end
