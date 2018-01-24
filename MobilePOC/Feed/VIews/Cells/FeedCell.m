
#import "FeedCell.h"
#import "Utility.h"
#import "FeedItemViewModel.h"
#import "UIImageView+UIActivityIndicatorForImage.h"

@interface FeedCell()
@property(nonatomic) FeedItemViewModel *feedItemViewModel;
@property (nonatomic, strong) UIImageView *ivBackgroundImageView;
@end
@implementation FeedCell
{
    NSMutableArray *constraints;
}

+(void)registerCellForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:NSStringFromClass([FeedCell class])];
}

#pragma mark - Initializers
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)updateConstraints{
    
    if (constraints){
        [super updateConstraints];
        return;
    }
    
    constraints = [NSMutableArray array];
    NSDictionary *metrics = @{@"LeftMargin":@8,@"RightMargin":@8};
    NSDictionary *views = @{@"baseView":_vBaseView,@"titleLabel":_lTitleLabel,@"imageView":_ivImageView,  @"backgroundImageView":_ivBackgroundImageView};
    
    //Base view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[baseView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[baseView]|" options:0 metrics:nil views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    
    //Background image view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundImageView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundImageView]|" options:0 metrics:nil views:views]];
    
    //Image view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_ivImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_vBaseView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_ivImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_ivImageView attribute:NSLayoutAttributeHeight multiplier:[_feedItemViewModel imageAspectRatio] constant:0]];
    
    //Title
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LeftMargin)-[titleLabel]-(RightMargin)-|" options:0 metrics:metrics views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_ivImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:2]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lTitleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_vBaseView attribute:NSLayoutAttributeBottom multiplier:1 constant:-4]];
    
    [self addConstraints:constraints];
    [super updateConstraints];
    
}

-(void)setNeedsUpdateConstraints{
    if (constraints){
        [self removeConstraints:constraints];
        constraints = nil;
        [super setNeedsUpdateConstraints];
    }
}

-(void)configureCellWithViewModel:(FeedItemViewModel *)feedItemViewModel{
    _feedItemViewModel = feedItemViewModel;
    _lTitleLabel.text = feedItemViewModel.titleLabelText;
}

#pragma mark - Private methods

-(void)commonInit{
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    //Create base view
    _vBaseView = [UIView new];
    [_vBaseView setBackgroundColor:CELL_BACKGROUND_COLOR];
    [self.contentView addSubview:_vBaseView];
    
    //Create background image view
    _ivBackgroundImageView = [UIImageView new];
    IMAGEVIEW_IMAGE(_ivBackgroundImageView, "card_layout_medium");
    [_vBaseView addSubview:_ivBackgroundImageView];
    
    // Create title label
    _lTitleLabel = [UILabel new];
    [_lTitleLabel setFont:[FeedItemViewModel titleLabelFont]];
    [_lTitleLabel setNumberOfLines:2];
 
    [_lTitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_vBaseView addSubview:_lTitleLabel];
    
    // Create image view
    _ivImageView = [UIImageView new];
    [_ivImageView setBackgroundColor:[UIColor lightGrayColor]];
    [_ivImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_ivImageView setClipsToBounds:YES];
    [_vBaseView addSubview:_ivImageView];
    
    PREPCONSTRAINTS(_vBaseView);
    PREPCONSTRAINTS(_ivImageView);
    PREPCONSTRAINTS(_lTitleLabel);
    PREPCONSTRAINTS(_ivBackgroundImageView);

}

@end
