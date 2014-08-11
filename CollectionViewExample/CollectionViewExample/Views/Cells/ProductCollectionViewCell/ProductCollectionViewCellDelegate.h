//
//  ProductCollectionViewCellDelegate.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/11/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductCollectionViewCell;

@protocol ProductCollectionViewCellDelegate <NSObject>

- (void)cell:(ProductCollectionViewCell *)cell didToogleFavoriteButton:(BOOL)on;

@end
