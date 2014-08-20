//
//  MainViewModel.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductCollectionViewModel;

@interface MainViewModel : NSObject

@property(nonatomic, readonly) ProductCollectionViewModel * productsViewModel;
@property(nonatomic, readonly) ProductCollectionViewModel * favoriteProductsViewModel;

- (instancetype)initWithRepository:(id<ProductRepository>)repository;

- (void)loadWithErrorHandler:(void(^)(NSError *))handler;

@end