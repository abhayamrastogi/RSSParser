
#import "FeedViewModel.h"
#import "APIManager.h"
#import "Feed.h"
#import "FeedItemViewModel.h"
#import "ImageDownloader.h"
#import "Utility.h"

#define kPadding 10

@interface FeedViewModel()
@property (strong, nonatomic) NSArray *feeds;
@end

@implementation FeedViewModel{
}

-(NSInteger)numberOfSections{
    return _feedItemViewModels.count > 0 ? 1 : 0;
}

-(NSInteger)numberOfRows{
    return _feedItemViewModels.count > 0 ? _feedItemViewModels.count - 1 : 0;
}

-(UIEdgeInsets)collectionViewSectionInset{
    return UIEdgeInsetsMake(0, kPadding, kPadding, kPadding);
}

-(NSInteger)collectionViewMinimumLineSpacing{
    return kPadding;
}

-(NSInteger)collectionViewMinimumInterItemSpacing{
    return kPadding;
}

#pragma mark - Fetch latest RSS feeds

// -------------------------------------------------------------------------------
//    fetchFeeds
// -------------------------------------------------------------------------------
-(void)fetchFeeds{
    
    [[APIManager sharedManager] fetchRSSFeeds:^(NSArray * _Nullable feeds, NSError * _Nullable error) {
        
        if (!feeds){
            [_delegate feedViewModel:self didFailWithNetworkError:error];
            return;
        }
        
        if (!_feedItemViewModels){
            _feedItemViewModels = [NSMutableArray array];
        }else{
            [_feedItemViewModels removeAllObjects];
        }
        
        _feeds = feeds;
    
        for(Feed *feed in _feeds){
            FeedItemViewModel *feedItemViewModel = [[FeedItemViewModel alloc] initWithFeed:feed];
            [_feedItemViewModels addObject:feedItemViewModel];
        }

        [_delegate feedViewModel:self fetchedFeeds:feeds];
    }];
    
}

// -------------------------------------------------------------------------------
//    itemViewModelForIndexPath:indexPath:
// -------------------------------------------------------------------------------
-(FeedItemViewModel *)itemViewModelForIndexPath:(NSIndexPath *)indexPath{
    return _feedItemViewModels[indexPath.row + 1];
}

// -------------------------------------------------------------------------------
//    itemViewModelForSection:section:
// -------------------------------------------------------------------------------
-(FeedItemViewModel *)itemViewModelForSection:(NSInteger)section{
    return [_feedItemViewModels firstObject];
}

// -------------------------------------------------------------------------------
//    sizeForItemAtIndexPath:indexPath
// ------------------------------------------------------------------------------
-(CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedItemViewModel *feedItemViewModel = [self itemViewModelForIndexPath:indexPath];
    
    NSInteger numberOfColumns = 2;
    if IS_IPAD{
        numberOfColumns = 3;
    }

    CGFloat contentWidth = (WINDOW_WIDTH - ([self collectionViewSectionInset].left + [self collectionViewSectionInset].right + (numberOfColumns - 1)*[self collectionViewMinimumInterItemSpacing]))/numberOfColumns;

    CGFloat cellHeight = 0.0;
    CGFloat imageHeight = contentWidth/[feedItemViewModel imageAspectRatio];
    CGFloat spacingBetweenImageAndTitle = 4;

    CGFloat titleLabelHeight = 2*21;
    CGFloat bottomMargin = 4;

    cellHeight = imageHeight + spacingBetweenImageAndTitle + titleLabelHeight + bottomMargin;
    return CGSizeMake(contentWidth, cellHeight);
}

// -------------------------------------------------------------------------------
//    referenceSizeForHeaderInSection:section
// -------------------------------------------------------------------------------
-(CGSize)referenceSizeForHeaderInSection:(NSInteger)section{
    FeedItemViewModel *feedItemViewModel = [self itemViewModelForSection:section];
    
    CGFloat headerHeight = 0.0;
    
    CGFloat imageHeight = WINDOW_WIDTH/[feedItemViewModel imageAspectRatio];
    
    CGFloat spacingBetweenImageAndTitle = 4;
   
    CGFloat titleLabelHeight = [feedItemViewModel titleLabelHeight];
    
    CGFloat spacingBetweenTitleAndDescription = 2;

    CGFloat descriptionLabelHeight = [feedItemViewModel descriptionLabelHeight];
    
    CGFloat bottomMargin = 32;

    headerHeight = imageHeight + spacingBetweenImageAndTitle + titleLabelHeight + spacingBetweenTitleAndDescription + descriptionLabelHeight + bottomMargin;
    return CGSizeMake(WINDOW_WIDTH, headerHeight);
}

@end
