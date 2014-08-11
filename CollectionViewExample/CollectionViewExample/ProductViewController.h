//
//  ProductViewController.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewModel.h"
#import "FavoriteButton.h"

@interface ProductViewController : UIViewController

@property(nonatomic) ProductViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet FavoriteButton *favoriteButton;

- (IBAction)favoriteButtonPressed:(id)sender;

@end
