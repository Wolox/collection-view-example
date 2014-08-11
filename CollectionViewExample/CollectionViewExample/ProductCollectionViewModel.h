//
//  ProductCollectionViewModel.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductViewModel;
@protocol ProductRepository;

@interface ProductCollectionViewModel : NSObject

- (instancetype)initWithRepository:(id<ProductRepository>)repository;

- (void)loadWithHandler:(void(^)(NSError *))handler;

- (ProductViewModel *)productAtIndex:(NSUInteger)index;

- (NSUInteger) productsCount;

@end
