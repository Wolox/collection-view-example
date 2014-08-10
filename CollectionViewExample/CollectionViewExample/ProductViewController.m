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

#pragma mark - Private Methods

- (void)renderViewModel {
    if (!self.viewModel) {
        return;
    }
    
    self.productNameLabel.text = self.viewModel.name;
    self.productPriceLabel.text = self.viewModel.price;
    __block typeof(self) this = self;
    [self.viewModel loadImageWithHandler:^(NSError * error, UIImage * image) {
        if (error) {
            NSLog(@"Image could not be loaded: %@", error);
        } else {
            this.productImageView.image = image;
        }
    }];
}

@end
