
#import "FeedViewController.h"
#import "FeedViewModel.h"
#import "Utility.h"
#import "FeedItemViewModel.h"
#import "FeedDetailViewController.h"
#import "FeedCell.h"
#import "UIImageView+UIActivityIndicatorForImage.h"
#import "FeedSectionHeaderView.h"
#import "CommonFunctions.h"
#import "EmptyStateView.h"

@interface FeedViewController ()<FeedViewModelDelegate, UICollectionViewDelegateFlowLayout, EmptyStateViewDelegate>
@property(nonatomic)UIRefreshControl *refreshControl;
@end

@implementation FeedViewController
{
    EmptyStateView *emptyStateView;
}

#pragma mark - Initialization
// -------------------------------------------------------------------------------
//    init
// -------------------------------------------------------------------------------
- (instancetype)initWithViewModel:(FeedViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        
        flowLayout.minimumLineSpacing = [_viewModel collectionViewMinimumLineSpacing];
        flowLayout.minimumInteritemSpacing = [_viewModel collectionViewMinimumInterItemSpacing];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = [_viewModel collectionViewSectionInset];
        return [self initWithCollectionViewLayout:flowLayout];
        
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark - Life cycle methods
// -------------------------------------------------------------------------------
//    viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self configureCollectionView];
    [self registerViews];
    [self configureRefreshControl];
    
    [_viewModel setDelegate:self];
    
    [self fetchFeeds];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

// -------------------------------------------------------------------------------
//    dealloc
//  If this view controller is going away, we need to cancel all outstanding downloads.
// -------------------------------------------------------------------------------
- (void)dealloc{
    // terminate all pending download connections
    [self terminateAllDownloads];
}

// -------------------------------------------------------------------------------
//    didReceiveMemoryWarning
// -------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Transition
-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateConstraintsForTraitCollection:newCollection];
    } completion:nil];
}

-(void)updateConstraintsForTraitCollection:(UITraitCollection *)collection{
    [self.collectionView reloadData];
}

#pragma mark - Private methods

-(void)setupNavigationBar{
    self.navigationItem.title = @"Investing – Daily Capital";
    self.navigationItem.rightBarButtonItem = BARBUTTONIMAGE([UIImage imageNamed:@"refresh"], @selector(refresh));
}

-(void)registerViews{
    [FeedCell registerCellForCollectionView:self.collectionView];
    [FeedSectionHeaderView registerSupplementaryViewForCollectionView:self.collectionView];
}

-(void)configureCollectionView{
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
}

-(void)configureRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFeeds) forControlEvents:UIControlEventValueChanged];
}

-(void)refresh{
    [self fetchFeeds];
}

-(void)fetchFeeds{
    [self.refreshControl beginRefreshing];
    [_viewModel fetchFeeds];
}

-(Feed *)feedAtIndexPath:(NSIndexPath *)indexPath{
    FeedItemViewModel *feedItemViewModel = [_viewModel itemViewModelForIndexPath:indexPath];
    return feedItemViewModel.feed;
}

-(void)showFeedDetailControllerForFeed:(Feed*)feed{
    FeedDetailViewController *feedDetailViewController = [[FeedDetailViewController alloc] init];
    feedDetailViewController.feed = feed;
    [self.navigationController showViewController:feedDetailViewController sender:self];
}

-(void)showEmptyStateView{
    [emptyStateView removeFromSuperview];
    
    emptyStateView = [EmptyStateView new];
    emptyStateView.delegate = self;
    [self.view addSubview:emptyStateView];
    
    PREPCONSTRAINTS(emptyStateView);
    CONSTRAIN(self.view, emptyStateView, @"H:|-0-[emptyStateView]-0-|");
    CONSTRAIN(self.view, emptyStateView, @"V:|-0-[emptyStateView(44)]");

}

-(void)hideEmptyStateView{
    [emptyStateView removeFromSuperview];
}

// -------------------------------------------------------------------------------
//    terminateAllDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllDownloads{
    
    // terminate all pending download connections
    NSArray *feedItemViewModels = _viewModel.feedItemViewModels;
    [feedItemViewModels makeObjectsPerformSelector:@selector(cancelDownload)];
}

-(void)downloadImage:(FeedItemViewModel *)feedItemViewModel forIndexPath:(NSIndexPath *)indexPath{
    [feedItemViewModel startDownload:^(UIImage * _Nullable image, NSError * _Nullable error) {
        FeedCell *cell = (FeedCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.ivImageView.image = image;
        [cell.ivImageView hideActivityIndicator];
    }];
}

- (void)renderImagesForVisibleRows{
    if (self.viewModel.numberOfRows > 0){
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths){
            FeedItemViewModel *feedItemViewModel = [self.viewModel itemViewModelForIndexPath:indexPath];
            
            if (!feedItemViewModel.image){
                [self downloadImage:feedItemViewModel forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - Actions
- (void)actionSectionHeaderTapGestureRecognizer:(id)sender{
    FeedItemViewModel *feedItemViewModel = [_viewModel itemViewModelForSection:0];
    Feed *feed = feedItemViewModel.feed;
    [self showFeedDetailControllerForFeed:feed];
}

#pragma mark - Collection view data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _viewModel.numberOfSections;
}

// -------------------------------------------------------------------------------
//    collectionview:numberOfRowsInSection:
//  Customize the number of rows in the collection view.
// -------------------------------------------------------------------------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _viewModel.numberOfRows;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedItemViewModel *feedItemViewModel = [_viewModel itemViewModelForIndexPath:indexPath];

    FeedCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FeedCell class]) forIndexPath:indexPath];

    [cell configureCellWithViewModel:feedItemViewModel];
    
    [cell.ivImageView showActivityIndicator];
    if (!feedItemViewModel.image){
        if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO){
            [self downloadImage:feedItemViewModel forIndexPath:indexPath];
        }
        cell.ivImageView.image = nil;
    }else{
        [cell.ivImageView hideActivityIndicator];
        cell.ivImageView.image = feedItemViewModel.image;
    }
    
    return cell;
}


// Section Header Create...
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        FeedItemViewModel *feedItemViewModel = [_viewModel itemViewModelForSection:[indexPath section]];

        FeedSectionHeaderView *
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([FeedSectionHeaderView class]) forIndexPath:indexPath];
        
        [headerView configureView:feedItemViewModel];
        return headerView;
    }
    
    return Nil;
}

#pragma mark - Collection view delegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Feed *feed = [self feedAtIndexPath:indexPath];
    [self showFeedDetailControllerForFeed:feed];
}

#pragma mark - Collection view flow layout delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_viewModel sizeForItemAtIndexPath:indexPath];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [_viewModel referenceSizeForHeaderInSection:section];
}

#pragma mark - FeedViewModelDelegate  methods
- (void)feedViewModel:(FeedViewModel *)viewModel fetchedFeeds:(NSMutableArray *)feeds {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self hideEmptyStateView];
        [self.collectionView reloadData];
    });
}

-(void)feedViewModel:(FeedViewModel *)viewModel didFailWithNetworkError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self showEmptyStateView];
        emptyStateView.lTitleLabel.text = @"You're offline, try connecting again";
    });
}

- (void)feedViewModel:(FeedViewModel *)viewModel failedToFetchFeedsWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        emptyStateView.lTitleLabel.text = @"Could not load feeds";
    });
}

#pragma mark -
-(void)emptyStateViewRefreshButtonPressed:(UIView *)view{
    [self refresh];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self renderImagesForVisibleRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self renderImagesForVisibleRows];
}

@end
