//
//  ProductFetcher.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductFetcher <NSObject>

- (void)fetchProductsWithHandler:(void(^)(NSError *, NSArray *))handler;

@end