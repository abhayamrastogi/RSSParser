
#import "EmptyStateView.h"
#import "Utility.h"

@implementation EmptyStateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5;
    [self setBackgroundColor:[UIColor blackColor]];
    
    // Create title label
    _lTitleLabel = [UILabel new];
    [_lTitleLabel setTextColor:[UIColor whiteColor]];
    [_lTitleLabel setFont:[UIFont systemFontOfSize:17]];
    [_lTitleLabel setNumberOfLines:1];
    [_lTitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self addSubview:_lTitleLabel];

    // Create button refresh
    _bButtonRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bButtonRefresh setTintColor:[UIColor whiteColor]];
    [_bButtonRefresh setImage:[[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_bButtonRefresh addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bButtonRefresh];
    
    [self setupConstraints];
}

-(void)setupConstraints{
    PREPCONSTRAINTS(_lTitleLabel);
    PREPCONSTRAINTS(_bButtonRefresh);
    
    //Refresh button
    CONSTRAIN(self, _bButtonRefresh, @"V:|[_bButtonRefresh]|");
    
    //Title label
    CONSTRAIN_VIEWS(self, @"H:|-8-[_lTitleLabel]-8-[_bButtonRefresh]-8-|", (@{@"_lTitleLabel":_lTitleLabel,@"_bButtonRefresh":_bButtonRefresh}));
    CONSTRAIN_HEIGHT(_lTitleLabel, 30);
    CENTER_VIEW_V(self, _lTitleLabel);

}

- (void)actionButtonPressed:(id)sender{
    [_delegate emptyStateViewRefreshButtonPressed:self];
}

@end
