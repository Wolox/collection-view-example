//
//  ProductCollectionViewControllerDelegate.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductCollectionViewController;
@class ProductViewModel;

@protocol ProductCollectionViewControllerDelegate <NSObject>

- (void)productCollection:(ProductCollectionViewController *)productCollection
         didSelectProduct:(ProductViewModel *)product;

@end
