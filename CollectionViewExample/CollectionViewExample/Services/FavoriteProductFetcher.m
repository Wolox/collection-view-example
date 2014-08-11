//
//  FavoriteProductFetcher.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "FavoriteProductFetcher.h"

#import "ProductRepository.h"

@interface FavoriteProductFetcher ()

@property(nonatomic) id<ProductRepository> repository;

@end

@implementation FavoriteProductFetcher

- (instancetype)initWithRepository:(id<ProductRepository>)repository {
    self = [super init];
    if (self) {
        self.repository = repository;
    }
    return self;
}

- (void)fetchProductsWithHandler:(void(^)(NSError *, NSArray *))handler {
    [self.repository fetchProductsWithQuery:@{@"favorite":@YES} andHandler:handler];
}

@end