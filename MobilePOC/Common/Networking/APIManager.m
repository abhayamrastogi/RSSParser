
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "XMLParser.h"
#import "Reachability.h"

// the http URL used for fetching the latest rss feeds
#define RSS_FEED_URL @"https://blog.personalcapital.com/feed/?cat=3,891,890,68,284"

@interface APIManager ()
// the queue to run our "XMLParser operation"
@property (nonatomic, strong) NSOperationQueue *queue;

// the NSOperation class to parse feeds in background thread
@property (nonatomic, strong) XMLParser *parser;
@end

@implementation APIManager

static APIManager *_sharedManager = nil;

+ (APIManager *)sharedManager {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (NetworkStatus)isNetworkAvailable {
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}

-(void)fetchXMLResourceWithName:(NSString *)name :(APIManagerDataHandler)completion{
    
    if ([self isNetworkAvailable] == NotReachable) {
       NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString( @"You're offline, try connecting again", @"You're offline, try connecting again" ) forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Mobile POC" code:-1001 userInfo:userInfo];
        completion(nil,error);
        return;
    }
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:name withExtension:@"xml"];
    
    if (url == nil){
        completion(nil, nil);
    }
    
    NSError *error;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if (!data){
        if (completion) {
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                completion(nil, error);
            }];
            return;
        }
    }
    
    self.queue = [[NSOperationQueue alloc] init];
    _parser = [[XMLParser alloc] initWithData:data];
    
    __weak APIManager *weakSelf = self;
    
    self.parser.errorHandler = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            completion(nil, error);
        });
    };
    
    __weak XMLParser *weakParser = self.parser;
    self.parser.completionBlock = ^{
        // The completion block may execute on any thread.  Because operations
        // involving the UI are about to be performed, make sure they execute on the main thread.
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (weakParser.feeds != nil){
                completion(weakParser.feeds,nil);
            }
        });
        
        // we are finished with the queue and our ParseOperation
        weakSelf.queue = nil;
    };
    
    [self.queue addOperation:self.parser];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

-(void)fetchRSSFeeds:(APIManagerDataHandler)completion{
    
    if ([self isNetworkAvailable] == NotReachable) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString( @"You're offline, try connecting again", @"You're offline, try connecting again" ) forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Mobile POC" code:-1001 userInfo:userInfo];
        completion(nil,error);
        return;
    }
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:RSS_FEED_URL]];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!data){
            if (completion) {
                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    completion(nil, error);
                }];
                return;
            }
        }
        
        self.queue = [[NSOperationQueue alloc] init];
        _parser = [[XMLParser alloc] initWithData:data];
        
        __weak APIManager *weakSelf = self;
        
        self.parser.errorHandler = ^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                completion(nil, error);
            });
        };
        
        __weak XMLParser *weakParser = self.parser;
        self.parser.completionBlock = ^{
            // The completion block may execute on any thread.  Because operations
            // involving the UI are about to be performed, make sure they execute on the main thread.
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (weakParser.feeds != nil){
                    completion(weakParser.feeds,nil);
                }
            });
            
            // we are finished with the queue and our ParseOperation
            weakSelf.queue = nil;
        };
        
        [self.queue addOperation:self.parser];
        
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [dataTask resume];
}

@end
