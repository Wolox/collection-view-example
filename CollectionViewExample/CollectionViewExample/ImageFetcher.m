//
//  ImageFetcher.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ImageFetcher.h"

typedef void (^CompletionHandler)(NSURLResponse * respondse, NSData * data, NSError * error);

@implementation ImageFetcher

- (instancetype)initWithImageURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        _imageURL = URL;
    }
    return self;
}

- (void)fetchImageWithHandler:(ImageHandler)imageHandler {
    NSURLRequest * request = [NSURLRequest requestWithURL: self.imageURL];
    NSOperationQueue * queue = [NSOperationQueue mainQueue];
    CompletionHandler handler = ^(NSURLResponse * response, NSData * data, NSError * error) {
        UIImage * image = nil;
        if (!error) {
            image = [[UIImage alloc] initWithData:data];
        }
        imageHandler(error, image);
    };
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

@end
