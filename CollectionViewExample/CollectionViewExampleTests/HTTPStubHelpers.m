//
//  HTTPStubHelpers.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 9/18/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "HTTPStubHelpers.h"

#import <OHHTTPStubs/OHHTTPStubs.h>

void stubHTTPImageRequest(NSURL * requestURL, NSString * imageFilePath) {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * request) {
        return [request.URL isEqual:requestURL];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSData * image = [NSData dataWithContentsOfFile:imageFilePath];
        return [OHHTTPStubsResponse responseWithData:image statusCode:200 headers:@{@"Content-Type": @"image/jpeg"}];
    }];
}