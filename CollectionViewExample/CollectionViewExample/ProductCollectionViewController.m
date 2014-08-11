//
//  ProductCollectionViewController.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductCollectionViewController.h"
#import "ProductCollectionViewCell.h"
#import "ProductCollectionViewCellDelegate.h"
#import "ProductCollectionViewModel.h"
#import "ProductViewModel.h"

#define CELL_WIDTH 320
#define CELL_HEIGHT 180

static NSString * const CellIdentifier = @"ProductCollectionViewCell";

@interface ProductCollectionViewController ()<ProductCollectionViewCellDelegate>

@property(nonatomic) ProductCollectionViewModel * viewModel;

@end

@implementation ProductCollectionViewController

- (instancetype)initWithViewModel:(ProductCollectionViewModel *)viewModel {
    UICollectionViewFlowLayout * layout = [self createLayoutFlow];
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.viewModel = viewModel;
        self.view.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self loadProducts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel productsCount];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                 forIndexPath:indexPath];
    ProductViewModel * product = [self.viewModel productAtIndex:indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return [self configureCell:cell forProduct:product];
}

#pragma mark - ProductCollectionViewCell Delegate Methods

- (void)cell:(ProductCollectionViewCell *)cell didToogleFavoriteButton:(BOOL)on {
    ProductViewModel * product = [self.viewModel productAtIndex:cell.indexPath.row];
    [product setFavorited:on withHandler:^(NSError * error) {
        if (error) {
            NSLog(@"Favorite property could not be set");
        } else {
            NSLog(@"Favortie property sucessfully set");
        }
    }];
}

#pragma mark - Private Methods

- (void)loadProducts {
    __block typeof(self) this = self;
    [self.viewModel loadWithHandler:^(NSError * error) {
        if (error) {
            NSLog(@"Error loading product collection: %@", error);
        } else {
            MAIN_THREAD([this.collectionView reloadData]);
        }
    }];
}

- (ProductCollectionViewCell *)configureCell:(ProductCollectionViewCell *)cell forProduct:(ProductViewModel *)product {
    cell.productNameLabel.text = product.name;
    cell.productPriceLabel.text = product.price;
    cell.productId = product.productId;
    cell.favoriteButton.on = product.favorited;
    [self loadProductImage:product forCell:cell];
    return cell;
}

- (void)loadProductImage:(ProductViewModel *)product forCell:(ProductCollectionViewCell *)cell {
    [cell setProductImage:nil];
    [product loadImageWithHandler:^(NSError * error, UIImage * image) {
        if (error) {
            NSLog(@"Product image could not be loaded: %@", error);
        } else {
            // This ensures that we are updating the cell we orinially intended to update.
            // This prevents updating a product image for cell that has already been reused.
            if ([cell.productId isEqualToString:product.productId]) {
                MAIN_THREAD([cell setProductImage:image]);
            } else {
                NSLog(@"Cell has been reused, image discarded!");
            }
        }
    }];
}

- (UICollectionViewFlowLayout *)createLayoutFlow {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (void)registerCell {
    UINib * cellNib = [UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
}

@end
