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
@property(nonatomic, getter = isLoaded) BOOL loaded;

@end

@implementation MainViewModel

- (instancetype)initWithRepository:(id<ProductRepository>)repository {
    self = [super init];
    if (self) {
        _repository = repository;
        _notificationCenter = [NSNotificationCenter defaultCenter];
        _loaded = NO;
        _productsViewModel = [[ProductCollectionViewModel alloc] initWithRepository:self.repository];
        _favoriteProductsViewModel = [[ProductCollectionViewModel alloc] initWithRepository:self.repository];
        _favoriteProductsViewModel.productFetcher = [[FavoriteProductFetcher alloc] initWithRepository:self.repository];
        [self registerNotificationHandlers];
    }
    return self;
}

- (void)dealloc {
    [self unregisterNotificationHandlers];
}

- (void)loadWithErrorHandler:(void(^)(NSError *))handler {
    if (!self.loaded) {
        [self.productsViewModel loadWithErrorHandler:handler];
        [self.favoriteProductsViewModel loadWithErrorHandler:handler];
    }
}

#pragma mark - Private Methods

- (void)registerNotificationHandlers {
    [self.notificationCenter addObserver:self
                                selector:@selector(markAsLoaded)
                                    name:ProductCollectionViewModelResetNotification
                                  object:nil];
    [self.notificationCenter addObserver:self
                                selector:@selector(handleFavoriteNotification:)
                                    name:ProductViewModelProductFavoritePropertyChangedNotification
                                  object:nil];
}

- (void)unregisterNotificationHandlers {
    [self.notificationCenter removeObserver:self name:ProductCollectionViewModelResetNotification object:nil];
    [self.notificationCenter removeObserver:self name:ProductViewModelProductFavoritePropertyChangedNotification object:nil];
}

- (void)markAsLoaded {
    self.loaded = YES;
}

- (void)handleFavoriteNotification:(NSNotification *) notification {
    ProductViewModel * productViewModel = notification.userInfo[ProductViewModelNotificationProductKey];
    if (productViewModel.favorited) {
        [self.favoriteProductsViewModel addProductViewModel:productViewModel];
    } else {
        [self.favoriteProductsViewModel removeProductViewModel:productViewModel];
    }
}

@end
