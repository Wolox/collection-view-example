//
//  ProductFactory.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface ProductFactory : NSObject

+ (instancetype)sharedFactory;

- (Product *)createProduct;

@end
