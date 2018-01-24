# MobilePOC

This sample demonstrates RSS latest feeds download, parsing and displayiny in UICollectionView.

It begins by loading the relevant text from the RSS feed so the table can load as quickly as possible, then downloads the feed images for each row asynchronously so the user interface is more responsive.

## Packaging Pist

AppDelegate.{h/m}
The app delegate class that show root controller.

APIManager.{h/m}
Manager class that downloads RSS feeds in the background using NSURLSession.

Feed.{h/m}
Wrapper object for each data entry, corresponding to a row in the table.

FeedViewController.{h/m}
UICollectionViewController subclass that builds the collection view in multiple stages, using feed data obtained from the APIManager.

FeedCell.{h/m}
UICollectionViewCell subclass that represent each feed in feed view controller row.

FeedViewModel.{h/m}
NSObject subclass is used to introduce presentation separation of feed view controller or view separate from model.

FeedViewModelDelegate.{h/m}
Protocol methods to communicate between feed view controller and feed view model.

FeedItemViewModel.{h/m}
NSObject subclass is used to introduce presentation separation of feed cell.

FeedDetailViewController.{h/m}
UIViewController subclass that load selected feed detail in webview.

EmptyStateView.{h/m}
UIView subclass containing title label and refresh button. It shows when no internet connection available or feeds could not load due to remote error.

XMLParser.{h/m}
Helper NSOperation object used to parse the XML RSS feed loaded by APIManager.

ImageDownloader.{h/m}
Helper class to download feed images. It uses NSURLSession/NSURLSessionDataTask to download the image in the background.

UIImageView+UIActivityIndicatorForImage.{h/m}
Category to add show/hide activityindicator functionality for UIImageView

UIView+Helpers.{h/m}

## Build Requirements
+ iOS 10.0 SDK or later

## Runtime Requirements
+ iOS 10.0 or later

