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
#import "FetchAllProductFetcher.h"

NSString * const ProductCollectionViewModelResetNotification = @"ProductCollectionViewModelNotification.Reset";
NSString * const ProductCollectionViewModelChangedNotification = @"ProductCollectionViewModelNotification.Changed";
NSString * const ProductCollectionViewModelProductAddedNotification = @"ProductCollectionViewModelNotification.ProductAdded";
NSString * const ProductCollectionViewModelProductRemovedNotification = @"ProductCollectionViewModelNotification.ProductRemoved";

NSString * const ProductCollectionViewModelNotificationProductKey = @"ProductCollectionViewModelNotification.Keys.Product";

@interface ProductCollectionViewModel () {
    NSMutableArray * _products;
}

@property(nonatomic) id<ProductRepository> repository;
@property(nonatomic) NSNotificationCenter * notificationCenter;

@end

@implementation ProductCollectionViewModel

- (instancetype)initWithRepository:(id<ProductRepository>)repository {
    return [self initWithProducts:@[] andRepository:repository];
}

- (instancetype)initWithProducts:(NSArray *)products andRepository:(id<ProductRepository>)repository {
    self = [super init];
    if (self) {
        _products = [self decorateProducts:products];
        self.repository = repository;
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        self.productFetcher = [[FetchAllProductFetcher alloc] initWithRepository:repository];
    }
    return self;
}

- (void)loadWithErrorHandler:(void(^)(NSError *))handler {
    __block typeof(self) this = self;
    [self.productFetcher fetchProductsWithHandler:^(NSError * error, NSArray * products){
        if (error) {
            handler(error);
        } else {
            [this setProducts:products];
        }
    }];
}

- (void)setProducts:(NSArray *)products {
    _products = [self decorateProducts:products];
    [self.notificationCenter postNotificationName:ProductCollectionViewModelResetNotification object:self];
}

- (void)addProductViewModel:(ProductViewModel *)productViewModel {
    [_products addObject:productViewModel];
    [self.notificationCenter postNotificationName:ProductCollectionViewModelProductAddedNotification
                                           object:self
                                         userInfo:@{ProductCollectionViewModelNotificationProductKey: productViewModel}];
    [self.notificationCenter postNotificationName:ProductCollectionViewModelChangedNotification object:self];
}

- (void)removeProductViewModel:(ProductViewModel *)productViewModel {
    [_products removeObject:productViewModel];
    [self.notificationCenter postNotificationName:ProductCollectionViewModelProductRemovedNotification
                                           object:self
                                         userInfo:@{ProductCollectionViewModelNotificationProductKey: productViewModel}];
    [self.notificationCenter postNotificationName:ProductCollectionViewModelChangedNotification object:self];
}

- (ProductViewModel *)productAtIndex:(NSUInteger)index {
    return [_products objectAtIndex:index];
}

- (NSUInteger) productsCount {
    return _products.count;
}

#pragma mark - Private Methods

- (NSMutableArray *)decorateProducts:(NSArray *)products {
    __block typeof(self) this = self;
    NSArray * viewModels = [products map:^(Product * product) {
        return [[ProductViewModel alloc] initWithProduct:product andRepository:this.repository];
    }];
    return [NSMutableArray arrayWithArray:viewModels];
}

@end
