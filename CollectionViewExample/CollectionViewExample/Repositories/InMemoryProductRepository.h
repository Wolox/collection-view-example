//
//  InMemoryUserRepository.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductRepository.h"

@interface InMemoryProductRepository : NSObject<ProductRepository>

- (void)addProduct:(Product *)product;

- (void)removeProduct:(Product *)product;

- (void)removeProductWithId:(NSString *)productId;

@end
