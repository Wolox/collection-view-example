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

@interface ViewController ()

@property(nonatomic) ProductViewModel * productViewModel;
@property(nonatomic) ProductCollectionViewController * productCollection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProductCollection];
    
    self.showProductButton.enabled = NO;
    [self fetchProduct];
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

- (ProductCollectionViewController *)createProductCollectionViewController {
    id<ProductRepository> repository = [[Application sharedInstance] productRepository];
    ProductCollectionViewModel * viewModel = [[ProductCollectionViewModel alloc] initWithRepository:repository];
    return [[ProductCollectionViewController alloc] initWithViewModel:viewModel];
}

- (void)initProductCollection {
    self.productCollection = [self createProductCollectionViewController];
    [self.productCollectionView addSubview:self.productCollection.view];
}

- (void)fetchProduct {
    __block typeof(self) this = self;
    id<ProductRepository> repository = [[Application sharedInstance] productRepository];
    NSString * productId = @"1";
    [repository fetchById:productId withHandler:^(NSError * error, Product * product){
        if (error) {
            NSLog(@"Product with ID %@ could not be fetched: %@", productId, error);
        } else {
            this.productViewModel = [[ProductViewModel alloc] initWithProduct:product andRepository:repository];
            MAIN_THREAD(self.showProductButton.enabled = YES);
        }
    }];
}

- (IBAction)showProductCollectionButtonPressed:(id)sender {
    UIViewController * controller = [self createProductCollectionViewController];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
