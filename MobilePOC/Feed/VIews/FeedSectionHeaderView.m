
#import "FeedSectionHeaderView.h"
#import "Utility.h"
#import "UIView+Helpers.h"
#import "FeedItemViewModel.h"
#import "UIImageView+UIActivityIndicatorForImage.h"

@interface NSObject ()
- (void)actionSectionHeaderTapGestureRecognizer:(id)sender;
@end

@interface FeedSectionHeaderView()<UIGestureRecognizerDelegate>
- (void)configureView:(FeedItemViewModel *)feedItemViewModel;
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@property(nonatomic) FeedItemViewModel *feedItemViewModel;
@property (nonatomic, strong) UIImageView *ivBackgroundImageView;

@end

@implementation FeedSectionHeaderView{
    NSMutableArray *constraints;
}

// -------------------------------------------------------------------------------
//    registerSupplementaryViewForCollectionView:collectionView:
// -------------------------------------------------------------------------------
+(void)registerSupplementaryViewForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[self class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([FeedSectionHeaderView class])];
}

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)aRect{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
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
    NSDictionary *views = @{@"baseView":_vBaseView,@"titleLabel":_lTitleLabel,@"descriptionLabel":_lDescriptionLabel,@"imageView":_ivImageView, @"backgroundImageView":_ivBackgroundImageView};
    
    //Base view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[baseView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[baseView]-32-|" options:0 metrics:nil views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    
    //Background image view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundImageView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundImageView]|" options:0 metrics:nil views:views]];
    

    //Image view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_ivImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_vBaseView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_ivImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_ivImageView attribute:NSLayoutAttributeHeight multiplier:[_feedItemViewModel imageAspectRatio] constant:0]];

    //Title
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LeftMargin)-[titleLabel]-(RightMargin)-|" options:0 metrics:metrics views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_ivImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:4]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[_feedItemViewModel titleLabelHeight]]];

    //Description
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LeftMargin)-[descriptionLabel]-(RightMargin)-|" options:0 metrics:metrics views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lDescriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lTitleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:2]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lDescriptionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_vBaseView attribute:NSLayoutAttributeBottom multiplier:1 constant:-4]];

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

#pragma mark - Private methods

- (void)commonInit{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //Create base view
    _vBaseView = [UIView new];
    [_vBaseView setBackgroundColor:CELL_BACKGROUND_COLOR];
    [self addSubview:_vBaseView];
    
    //Create background image view
    _ivBackgroundImageView = [UIImageView new];
    IMAGEVIEW_IMAGE(_ivBackgroundImageView, "card_layout_large");
    [_vBaseView addSubview:_ivBackgroundImageView];
    
    // Create title label
    _lTitleLabel = [UILabel new];
    [_lTitleLabel setFont:[FeedItemViewModel titleLabelFont]];
    [_lTitleLabel setNumberOfLines:1];
    [_lTitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_vBaseView addSubview:_lTitleLabel];
    
    // Create description label
    _lDescriptionLabel = [UILabel new];
    UIFont *font = [FeedItemViewModel descriptionLabelFont];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    [_lDescriptionLabel.attributedText setValuesForKeysWithDictionary:attrsDictionary];
    [_lDescriptionLabel setNumberOfLines:2];
    [_lDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_vBaseView addSubview:_lDescriptionLabel];
    
    // Create image view
    _ivImageView = [UIImageView new];
    [_ivImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_ivImageView setClipsToBounds:YES];
    [_vBaseView addSubview:_ivImageView];
    
    PREPCONSTRAINTS(_vBaseView);
    PREPCONSTRAINTS(_ivImageView);
    PREPCONSTRAINTS(_lTitleLabel);
    PREPCONSTRAINTS(_lDescriptionLabel);
    PREPCONSTRAINTS(_ivBackgroundImageView);

    [self configureTapGestureRecognizer];
}


// -------------------------------------------------------------------------------
//    configureTapGestureRecognizer
// -------------------------------------------------------------------------------
- (void)configureTapGestureRecognizer{
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTapGestureRecognizer)];
    _tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:_tapGesture];
}


// -------------------------------------------------------------------------------
//    downloadImage:feedItemViewModel:
// -------------------------------------------------------------------------------
-(void)downloadImage:(FeedItemViewModel *)feedItemViewModel{
    [feedItemViewModel startDownload:^(UIImage * _Nullable image, NSError * _Nullable error) {
        _ivImageView.image = image;
        [_ivImageView hideActivityIndicator];
    }];
}

#pragma mark - Public methods
// -------------------------------------------------------------------------------
//    configureView:feedItemViewModel:
// -------------------------------------------------------------------------------
- (void)configureView:(FeedItemViewModel *)feedItemViewModel{
    _feedItemViewModel = feedItemViewModel;
    _lTitleLabel.text = feedItemViewModel.titleLabelText;
    _lDescriptionLabel.attributedText = feedItemViewModel.descriptionLabelText;
    
    [_ivImageView showActivityIndicator];
    if (!feedItemViewModel.image){
        [self downloadImage:feedItemViewModel];
        _ivImageView.image = [UIImage imageNamed:@"placeholder"];
    }else{
        [_ivImageView hideActivityIndicator];
        _ivImageView.image = feedItemViewModel.image;
    }
}

#pragma mark - Actions
// -------------------------------------------------------------------------------
//    actionTapGestureRecognizer
// -------------------------------------------------------------------------------
-(void)actionTapGestureRecognizer{
    SEL action;
    action = @selector(actionSectionHeaderTapGestureRecognizer:);
    [self sendAction:action from:self];
}


@end

