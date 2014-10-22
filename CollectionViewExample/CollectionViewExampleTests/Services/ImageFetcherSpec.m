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
    NSURL * imageURL = [[NSURL alloc] initWithString:@"http://localhost:8080/test.png"];
    imageFetcher = [[ImageFetcher alloc] initWithImageURL:imageURL];
});

afterEach(^{
    imageFetcher = nil;
});

afterAll(^{
    [OHHTTPStubs removeAllStubs];
});

describe(@"#fetchImageWithHandler:", ^{
    context(@"when called with a valid handler", ^{
        it(@"invoke the handler", ^AsyncBlock{
            [imageFetcher fetchImageWithHandler:^(NSError * error, UIImage * image) {
                done();
            }];
        });
    });
});


SpecEnd