//
//  ImageFetcherSpec.m
//  CollectionViewExample
//
//  Created by Tomás Mehdi on 10/22/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "SpecHelper.h"
#import "ImageFetcher.h"

SpecBegin(ImageFetcher)

__block ImageFetcher * imageFetcher = nil;


beforeEach(^{
    NSURL * URL = [[NSURL alloc] initWithString:@"string"];
    imageFetcher = [[ImageFetcher alloc] initWithImageURL:URL];
});

afterEach(^{
    imageFetcher = nil;
});

describe(@"#fetchImageWithHandler:", ^{
    context(@"Called with a valid handler", ^{
        it(@"Call the handler", ^AsyncBlock{
            [imageFetcher fetchImageWithHandler:^(NSError * error, UIImage * image) {
                done();
            }];
        });
    });
});


SpecEnd