//
//  ProductViewController.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self renderViewModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Actions

- (IBAction)favoriteButtonPressed:(id)sender {
    BOOL previousState = self.favoriteButton.on;
    [self.favoriteButton toggle];
    __block typeof(self) this = self;
    [self.viewModel setFavorited:self.favoriteButton.on withHandler:^(NSError * error) {
        if (error) {
            NSLog(@"Product favorite property could not be set to %@: %@",
                  (this.favoriteButton.on) ? @"YES" : @"NO", error);
            // TODO handler multiple call. In such case
            // calls to the API should be serialized
            MAIN_THREAD(this.favoriteButton.on = previousState);
        }
    }];
}

#pragma mark - Private Methods

- (void)renderViewModel {
    if (!self.viewModel) {
        return;
    }
    
    self.productNameLabel.text = self.viewModel.name;
    self.productPriceLabel.text = self.viewModel.price;
    self.productDescriptionTextView.text = self.viewModel.productDescription;
    self.favoriteButton.on = self.viewModel.favorited;
    [self loadProductImage];
}

- (void)loadProductImage {
    __block typeof(self) this = self;
    [self.viewModel loadImageWithHandler:^(NSError * error, UIImage * image) {
        if (error) {
            NSLog(@"Image could not be loaded: %@", error);
        } else {
            MAIN_THREAD(this.productImageView.image = image);
        }
    }];
}

@end
