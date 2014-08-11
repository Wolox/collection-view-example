//
//  ProductCollectionViewModel.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductCollectionViewModel.h"
#import "ProductRepository.h"
#import "ProductViewModel.h"

@interface ProductCollectionViewModel ()

@property(nonatomic) NSArray * products;
@property(nonatomic) id<ProductRepository> repository;

@end

@implementation ProductCollectionViewModel

- (instancetype)initWithRepository:(id<ProductRepository>)repository {
    self = [super init];
    if (self) {
        self.products = @[];
        self.repository = repository;
    }
    return self;
}

- (void)loadWithHandler:(void(^)(NSError *))handler {
    __block typeof(self) this = self;
    [self.repository fetchProductsWithHandler:^(NSError * error, NSArray * products){
        if (error) {
            handler(error);
        } else {
            this.products = [products map:^(Product * product) {
                return [[ProductViewModel alloc] initWithProduct:product andRepository:this.repository];
            }];
            handler(nil);
        }
    }];
}

- (ProductViewModel *)productAtIndex:(NSUInteger)index {
    return [self.products objectAtIndex:index];
}

- (NSUInteger) productsCount {
    return self.products.count;
}

@end
