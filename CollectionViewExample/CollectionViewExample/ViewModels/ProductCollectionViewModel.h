//
//  ProductCollectionViewModel.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ProductCollectionViewModelResetNotification;
extern NSString * const ProductCollectionViewModelChangedNotification;
extern NSString * const ProductCollectionViewModelProductAddedNotification;
extern NSString * const ProductCollectionViewModelProductRemovedNotification;

extern NSString * const ProductCollectionViewModelNotificationProductKey;


@class ProductViewModel;
@protocol ProductRepository;
@protocol ProductFetcher;

@interface ProductCollectionViewModel : NSObject

@property(nonatomic) id<ProductFetcher> productFetcher;

- (instancetype)initWithRepository:(id<ProductRepository>)repository;

- (instancetype)initWithProducts:(NSArray *)products andRepository:(id<ProductRepository>)repository;

- (void)loadWithErrorHandler:(void(^)(NSError *))handler;

- (void)setProducts:(NSArray *)products;

- (void)addProductViewModel:(ProductViewModel *)productViewModel;

- (void)removeProductViewModel:(ProductViewModel *)productViewModel;

- (ProductViewModel *)productAtIndex:(NSUInteger)index;

- (NSUInteger) productsCount;

@end
