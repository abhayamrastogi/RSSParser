
#import <Foundation/Foundation.h>

@interface XMLParser : NSOperation <NSXMLParserDelegate>

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// NSArray containing feed instances for each entry parsed
// from the input data.
// Only meaningful after the operation has completed.
@property (nonatomic, strong, readonly) NSArray *feeds;

// The initializer for this NSOperation subclass.
- (instancetype)initWithData:(NSData *)data;
@end
