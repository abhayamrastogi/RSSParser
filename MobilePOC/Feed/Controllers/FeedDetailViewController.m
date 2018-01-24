
#import "FeedDetailViewController.h"
#import "Feed.h"
#import <WebKit/WebKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"
#import "EmptyStateView.h"
#import "CommonFunctions.h"

#pragma mark - properties
@interface FeedDetailViewController ()<UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation FeedDetailViewController
{
    EmptyStateView *emptyStateView;
}

#pragma mark - Life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self configureWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showActivityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods
-(void)setupNavigationBar{
    self.navigationItem.title = _feed.title;
}

- (void)configureWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView setScalesPageToFit:YES];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    NSURL *url = [[NSURL alloc] initWithString:_feed.link];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

-(void)showAlert:(NSString*) title message:(NSString *) messageText{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title
                                                                  message:messageText
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action){
                                                     }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showActivityIndicator{
    
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped = YES;
        self.activityIndicator.userInteractionEnabled = FALSE;
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.view addSubview:self.activityIndicator];
            [self.activityIndicator startAnimating];
            [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:FALSE];
            CENTER_VIEW(self.view, self.activityIndicator);
        }];
    }else{
        [self.activityIndicator startAnimating];
    }
}

- (void)hideActivityIndicator{
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.activityIndicator stopAnimating];
    }];
}

-(void)showEmptyStateView{
    [emptyStateView removeFromSuperview];
    
    emptyStateView = [EmptyStateView new];
    [self.view addSubview:emptyStateView];
    
    emptyStateView.lTitleLabel.text = @"You're offline, try connecting again";
    
    PREPCONSTRAINTS(emptyStateView);
    CONSTRAIN(self.view, emptyStateView, @"H:|-0-[emptyStateView]-0-|");
    CONSTRAIN(self.view, emptyStateView, @"V:|-0-[emptyStateView(44)]");
    
}

#pragma mark - UIWebView delegate methods

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self hideActivityIndicator];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self hideActivityIndicator];
    
    NSString *errorMessage = [error localizedDescription];
    showAlertFromController(self, NSLocalizedString(@"Cannot laod feed detail", @""), errorMessage);
    
}

@end
