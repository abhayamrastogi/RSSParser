
#import "XMLParser.h"
#import "Feed.h"
#import "MediaContent.h"

// string contants found in the RSS feed
static NSString *kTitle     = @"title";
static NSString *kLink   = @"link";
static NSString *kMediaContent  = @"media:content";
static NSString *kDescription = @"description";
static NSString *kPubDate  = @"pubDate";
static NSString *kURL  = @"url";
static NSString *kItem  = @"item";
static NSString *kHeight  = @"height";
static NSString *kWidth  = @"width";

@interface XMLParser () <NSXMLParserDelegate>

// Redeclare appRecordList so we can modify it within this class
@property (nonatomic, strong) NSArray *feeds;

@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) NSMutableArray *workingArray;
@property (nonatomic, strong) Feed *workingEntry;  // the current app record or XML entry being parsed
@property (nonatomic, strong) NSMutableString *workingPropertyString;
@property (nonatomic, strong) NSArray *elementsToParse;
@property (nonatomic, readwrite) BOOL storingCharacterData;

@end

@implementation XMLParser

// -------------------------------------------------------------------------------
//    initWithData:
// -------------------------------------------------------------------------------
- (instancetype)initWithData:(NSData *)data{
    self = [super init];
    if (self != nil){
        _dataToParse = data;
        _elementsToParse = @[kTitle, kLink, kDescription, kPubDate];
    }
    return self;
}

// -------------------------------------------------------------------------------
//    main
//  Entry point for the operation.
//  Given data to parse, use NSXMLParser and process all the top paid apps.
// -------------------------------------------------------------------------------
- (void)main{
    
    // The default implemetation of the -start method sets up an autorelease pool
    // just before invoking -main however it does NOT setup an excption handler
    // before invoking -main.  If an exception is thrown here, the app will be
    // terminated.
    
    _workingArray = [NSMutableArray array];
    _workingPropertyString = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
    // desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.dataToParse];
    [parser setDelegate:self];
    [parser parse];
    
    if (![self isCancelled]){
        // Set appRecordList to the result of our parsing
        self.feeds = [NSArray arrayWithArray:self.workingArray];
    }
    
    self.workingArray = nil;
    self.workingPropertyString = nil;
    self.dataToParse = nil;
}

#pragma mark - XMLParser delegate methods

// -------------------------------------------------------------------------------
//    parser:didStartElement:namespaceURI:qualifiedName:attributes:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:kItem])
    {
        self.workingEntry = [[Feed alloc] init];
    }
    self.storingCharacterData = [self.elementsToParse containsObject:elementName];
    
    if ([elementName isEqualToString:kMediaContent]) {
        MediaContent *mediaContent = [MediaContent new];
        if (attributeDict[kURL]){
            mediaContent.url = attributeDict[kURL];
        }
        if (attributeDict[kWidth]){
            mediaContent.width = [attributeDict[kWidth] floatValue];
        }
        if (attributeDict[kHeight]){
            mediaContent.height = [attributeDict[kHeight] floatValue];
        }
        self.workingEntry.mediaContent = mediaContent;
        
    }
}

// -------------------------------------------------------------------------------
//    parser:didEndElement:namespaceURI:qualifiedName:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if (self.workingEntry != nil)
    {
        if (self.storingCharacterData)
        {
            NSString *trimmedString =
            [self.workingPropertyString stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:kTitle])
            {
                self.workingEntry.title = trimmedString;
            }
            else if ([elementName isEqualToString:kLink])
            {
                self.workingEntry.link = trimmedString;
            }
            else if ([elementName isEqualToString:kPubDate])
            {
                self.workingEntry.pubDate = trimmedString;
            }
            else if ([elementName isEqualToString:kDescription])
            {
                self.workingEntry.feedDescription = trimmedString;
            }
        }else if ([elementName isEqualToString:kItem])
        {
            [self.workingArray addObject:self.workingEntry];
            self.workingEntry = nil;
        }
    }
}

// -------------------------------------------------------------------------------
//    parser:foundCharacters:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ((self.workingEntry) && (self.storingCharacterData)){
        [self.workingPropertyString appendString:string];
    }
}

// -------------------------------------------------------------------------------
//    parser:parseErrorOccurred:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (self.errorHandler){
        self.errorHandler(parseError);
    }
}

@end
