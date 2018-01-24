
#import "Feed.h"

@implementation Feed

// -------------------------------------------------------------------------------
//    link: appending ?displayMobileNavigation=0 for mobile
// -------------------------------------------------------------------------------
-(NSString *)link{
    if (!_link) {
        return @"";
    }else{
        NSURLComponents *components = [NSURLComponents componentsWithString:_link];
        NSURLQueryItem *navigation = [NSURLQueryItem queryItemWithName:@"displayMobileNavigation" value:@"0"];
        components.queryItems = @[navigation];
        return components.string;
    }
}

@end
