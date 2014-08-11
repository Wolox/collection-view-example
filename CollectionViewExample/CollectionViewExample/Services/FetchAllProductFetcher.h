//
//  FetchAllProductFetcher.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductFetcher.h"

@protocol ProductRepository;

@interface FetchAllProductFetcher : NSObject<ProductFetcher>

- (instancetype)initWithRepository:(id<ProductRepository>)repository;

@end
