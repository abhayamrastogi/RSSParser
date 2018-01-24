
#import <Foundation/Foundation.h>

typedef void (^APIManagerErrorHandler)(NSError * _Nullable error);
typedef void (^APIManagerDataHandler)(NSArray * _Nullable feeds, NSError * _Nullable error);

@interface APIManager : NSObject
+ (APIManager *_Nonnull)sharedManager;
-(void)fetchXMLResourceWithName:(NSString *_Nonnull)name :(APIManagerDataHandler _Nonnull )completion;
-(void)fetchRSSFeeds:(APIManagerDataHandler _Nullable )completion;
@end
