//
//  MainViewModel.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "MainViewModel.h"
#import "ProductCollectionViewModel.h"
#import "ProductRepository.h"
#import "ProductViewModel.h"
#import "FavoriteProductFetcher.h"

@interface MainViewModel ()

@property(nonatomic) id<ProductRepository> repository;
@property(nonatomic) NSNotificationCenter * notificationCenter;

@end

@implementation MainViewModel

- (instancetype)initWithRepository:(id<ProductRepository>)repository {
    self = [super init];
    if (self) {
        self.repository = repository;
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        _productsViewModel = [[ProductCollectionViewModel alloc] initWithRepository:self.repository];
        _favoriteProductsViewModel = [[ProductCollectionViewModel alloc] initWithRepository:self.repository];
        _favoriteProductsViewModel.productFetcher = [[FavoriteProductFetcher alloc] initWithRepository:self.repository];
    }
    return self;
}

- (void)loadWithErrorHandler:(void(^)(NSError *))handler {
    [self.productsViewModel loadWithErrorHandler:handler];
    [self.favoriteProductsViewModel loadWithErrorHandler:handler];
}

- (void)registerNotificationHandlers {
    [self.notificationCenter addObserver:self
                                selector:@selector(handleFavoriteNotification:)
                                    name:ProductViewModelProductFavoriteChangedNotification
                                  object:nil];
}

- (void)unregisterNotificationHandlers {
    [self.notificationCenter removeObserver:self name:ProductViewModelProductFavoriteChangedNotification object:nil];
}

#pragma mark - Private Methods

- (void)handleFavoriteNotification:(NSNotification *) notification {
    ProductViewModel * productViewModel = notification.userInfo[ProductViewModelNotificationProductKey];
    if (productViewModel.favorited) {
        [self.favoriteProductsViewModel addProductViewModel:productViewModel];
    } else {
        [self.favoriteProductsViewModel removeProductViewModel:productViewModel];
    }
}

@end
