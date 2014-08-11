//
//  ImageFetcher.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageHandler)(NSError *, UIImage *);

@interface ImageFetcher : NSObject

@property(readonly, nonatomic) NSURL * imageURL;

- (instancetype)initWithImageURL:(NSURL *)URL;

- (void)fetchImageWithHandler:(ImageHandler)handler;

@end
