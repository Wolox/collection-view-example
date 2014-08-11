//
//  ViewController.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ViewController.h"

#import "ProductRepository.h"
#import "ProductViewController.h"
#import "ProductCollectionViewModel.h"
#import "ProductCollectionViewController.h"
#import "ProductCollectionViewControllerDelegate.h"
#import "MainViewModel.h"

static NSString * const ShowProductSegue = @"ShowProduct";

@interface ViewController ()<ProductCollectionViewControllerDelegate>

@property(nonatomic) ProductViewModel * selectedProduct;
@property(nonatomic) MainViewModel * viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[MainViewModel alloc] initWithRepository:[[Application sharedInstance] productRepository]];
    [self initChildControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.viewModel registerNotificationHandlers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.viewModel unregisterNotificationHandlers];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.viewModel loadWithErrorHandler:^(NSError * error) {
        if (error) {
            NSLog(@"Product collection could not be fetched!");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ShowProductSegue]) {
        ProductViewController * controller = segue.destinationViewController;
        controller.viewModel = self.selectedProduct;
    }
}

#pragma mark - ProductCollectionViewController Delegate Methods

- (void)productCollection:(ProductCollectionViewController *)productCollection
         didSelectProduct:(ProductViewModel *)product {
    self.selectedProduct = product;
    [self performSegueWithIdentifier:ShowProductSegue sender:self];
}

#pragma mark - Private Methods

- (ProductCollectionViewController *)newProductCollectionWithViewModel:(ProductCollectionViewModel *)viewModel {
    ProductCollectionViewController * controller = [[ProductCollectionViewController alloc] initWithViewModel:viewModel];
    controller.delegate = self;
    [self addChildViewController:controller];
    return controller;
}

- (void)initChildControllers {
    ProductCollectionViewController * controller;
    controller = [self newProductCollectionWithViewModel:self.viewModel.productsViewModel];
    [self.productCollectionView addSubview:controller.view];
    controller = [self newProductCollectionWithViewModel:self.viewModel.favoriteProductsViewModel];
    [self.favoritedProductsCollectionView addSubview:controller.view];
}

@end
