
#import "AppDelegate.h"
#import "Utility.h"
#import "FeedViewController.h"
#import "FeedViewModel.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

// -------------------------------------------------------------------------------
//    application:didFinishLaunchingWithOptions:
// -------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = PRIMARY_COLOR;
    
    FeedViewModel *viewModel = [[FeedViewModel alloc] init];
    FeedViewController *feedViewController = [[FeedViewController alloc] initWithViewModel:viewModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedViewController];
    [navigationController.navigationBar setTranslucent:FALSE];
    _window.rootViewController = navigationController;
    [_window makeKeyAndVisible];

    return YES;
}


// -------------------------------------------------------------------------------
//    handleError:error
//  Reports any error with an alert which was received from connection or loading failures.
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error{
    NSString *errorMessage = [error localizedDescription];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot Show RSS Feeds", @"")
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         // dissmissal of alert completed
                                                     }];
    
    [alert addAction:OKAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
