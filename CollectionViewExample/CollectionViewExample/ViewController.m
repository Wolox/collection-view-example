//
//  ViewController.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ViewController.h"

#import "Product.h"
#import "ProductViewController.h"
#import "ProductFactory.h"

@interface ViewController ()

@property(nonatomic) ProductViewModel * productViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.productViewModel = [self createProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProduct"]) {
        ProductViewController * controller = segue.destinationViewController;
        controller.viewModel = self.productViewModel;
    }
}

#pragma mark - Private Methods

- (ProductViewModel *)createProduct {
    Product * product = [[ProductFactory sharedFactory] createProduct];
    return [[ProductViewModel alloc] initWithProduct:product];
}

@end
