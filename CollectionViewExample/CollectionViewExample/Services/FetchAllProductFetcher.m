//
//  FetchAllProductFetcher.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "FetchAllProductFetcher.h"
#import "ProductRepository.h"

@interface FetchAllProductFetcher ()

@property(nonatomic) id<ProductRepository> repository;

@end

@implementation FetchAllProductFetcher

- (instancetype)initWithRepository:(id<ProductRepository>)repository {
    self = [super init];
    if (self) {
        _repository = repository;
    }
    return self;
}

- (void)fetchProductsWithHandler:(void(^)(NSError *, NSArray *))handler {
    [self.repository fetchProductsWithHandler:handler];
}

@end
