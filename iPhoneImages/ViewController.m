//
//  ViewController.m
//  iPhoneImages
//
//  Created by Angie Linton on 2017-01-30.
//  Copyright © 2017 Angie Linton. All rights reserved.
//

#import "ViewController.h"
#import "iPhoneImageView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet iPhoneImageView *iPhoneImageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object. The default system values are good for now, so we'll just grab the default configuration.
//    We create a task that will actually download the image from the server. The session creates and configures the task and the task makes the request. Download tasks retrieve data in the form of a file, and support background downloads and uploads while the app is not running. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
//        A task is created in a suspended state, so we need to resume it. We can also You can also suspend, resume and cancel tasks whenever we want.
    
    
    NSURL *url = [NSURL URLWithString:@"http://imgur.com/CoQ8aNl.png"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *_Nullable location, NSURLResponse * _Nullable response, NSError *_Nullable error){
        
        if (error) {
            NSLog(@"error:%@", error.localizedDescription);
            return;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.iPhoneImageView.image = image;
            
        }];

    }];
    [downloadTask resume];
}

//       ^^ The completion handler takes 3 parameters:
//        
//    location: The location of a file we just downloaded on the device.
//    response: Response metadata such as HTTP headers and status codes.
//    error: An NSError that indicates why the request failed, or nil when the request is successful.
//If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
//The download task downloads the file to the iPhone then lets us know the location of the download using a local URL. In order to access this as a UIImage object, we need to first convert the file's binary into an NSData object, then create a UIImage from that data.
//The only thing left to do is display the image on the screen. This is almost as simple as self.iPhoneImageView.image = image; however the networking happens on a background thread and the UI can only be updated on the main thread. This means that we need to make sure that this line of code runs on the main thread.

@end
