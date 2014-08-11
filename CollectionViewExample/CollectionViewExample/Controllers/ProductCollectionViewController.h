//
//  ProductCollectionViewController.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCollectionViewModel;
@protocol ProductCollectionViewControllerDelegate;

@interface ProductCollectionViewController : UICollectionViewController

@property(weak, nonatomic) id<ProductCollectionViewControllerDelegate>delegate;

- (instancetype)initWithViewModel:(ProductCollectionViewModel *)viewModel;

@end
