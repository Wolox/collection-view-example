//
//  ProductCollectionViewCell.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteButton.h"

@protocol ProductCollectionViewCellDelegate;

@interface ProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<ProductCollectionViewCellDelegate>delegate;
@property (nonatomic) NSString * productId;
@property (nonatomic) NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet FavoriteButton *favoriteButton;



- (IBAction)favoriteButtonPressed:(id)sender;

- (void)setProductImage:(UIImage *)image;

@end
