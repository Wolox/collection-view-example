//
//  ProductCollectionViewCell.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductCollectionViewCell.h"
#import "ProductCollectionViewCellDelegate.h"

@implementation ProductCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)favoriteButtonPressed:(id)sender {
    [self.favoriteButton toggle];
    [self.delegate cell:self didToogleFavoriteButton:self.favoriteButton.on];
}

- (void)setProductImage:(UIImage *)image {
    self.productImageView.image = image;
}


@end
