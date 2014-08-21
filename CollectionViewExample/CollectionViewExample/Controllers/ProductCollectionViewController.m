//
//  ProductCollectionViewController.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductCollectionViewController.h"
#import "ProductCollectionViewControllerDelegate.h"
#import "ProductCollectionViewCell.h"
#import "ProductCollectionViewCellDelegate.h"
#import "ProductCollectionViewModel.h"
#import "ProductViewModel.h"

#define CELL_WIDTH 320
#define CELL_HEIGHT 180

static NSString * const CellIdentifier = @"ProductCollectionViewCell";

@interface ProductCollectionViewController ()<ProductCollectionViewCellDelegate>

@property(nonatomic) ProductCollectionViewModel * viewModel;
@property(nonatomic) NSNotificationCenter * notificationCenter;
@property(nonatomic, weak) id resetObserver;
@property(nonatomic, weak) id changedObserver;

@end

@implementation ProductCollectionViewController

- (instancetype)initWithViewModel:(ProductCollectionViewModel *)viewModel {
    UICollectionViewFlowLayout * layout = [self createLayoutFlow];
    if (self = [super initWithCollectionViewLayout:layout]) {
        _viewModel = viewModel;
        _notificationCenter = [NSNotificationCenter defaultCenter];
        // This should not be necesary if we use autolayout but
        // we are not using it because is not necesary for this
        // example app. Yet.
        self.view.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.collectionView reloadData];
    [self registerNotificationHandlers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterNotificationHandlers];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductViewModel * product = [self.viewModel productAtIndex:indexPath.row];
    [self.delegate productCollection:self didSelectProduct:product];
}

#pragma mark - ProductCollectionViewCell Delegate Methods

- (void)cell:(ProductCollectionViewCell *)cell didToogleFavoriteButton:(BOOL)on {
    ProductViewModel * product = [self.viewModel productAtIndex:cell.indexPath.row];
    [product setFavorited:on withHandler:^(NSError * error) {
        if (error) {
            NSLog(@"Favorite property could not be set");
        }
    }];
}

#pragma mark - Private Methods

- (void)registerNotificationHandlers {
    __block typeof(self) this = self;
    void(^handler)(NSNotification *) = ^(NSNotification * note) {
        [this.collectionView reloadData];
    };
    [self registerCollectionResetNotificationHandler:handler];
    [self registerCollectionChangedNotificationHandler:handler];
    [self registerProductFavoriteChangedNotificationHandler];
}

- (void)unregisterNotificationHandlers {
    [self unregisterCollectionResetNotificationHandler];
    [self unregisterCollectionChangedNotificationHandler];
    [self unregisterProductFavoriteChangedNotificationHandler];
}

- (void)registerCollectionResetNotificationHandler:(void(^)(NSNotification *))handler {
    self.resetObserver = [self.notificationCenter addObserverForName:ProductCollectionViewModelResetNotification
                                                              object:self.viewModel
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:handler];
}

- (void)unregisterCollectionResetNotificationHandler {
    [self.notificationCenter removeObserver:self.resetObserver];
}

- (void)registerCollectionChangedNotificationHandler:(void(^)(NSNotification *))handler {
    self.changedObserver = [self.notificationCenter addObserverForName:ProductCollectionViewModelChangedNotification
                                                                object:self.viewModel
                                                                 queue:[NSOperationQueue mainQueue]
                                                            usingBlock:handler];
}

- (void)unregisterCollectionChangedNotificationHandler {
    [self.notificationCenter removeObserver:self.changedObserver];
}

- (void)registerProductFavoriteChangedNotificationHandler {
    [self.notificationCenter addObserver:self
                                selector:@selector(handleProductFavoritePropertyChange:)
                                    name:ProductViewModelProductFavoriteChangedNotification
                                  object:nil];
}

- (void)unregisterProductFavoriteChangedNotificationHandler {
    [self.notificationCenter removeObserver:self name:ProductViewModelProductFavoriteChangedNotification object:nil];
}

- (void)handleProductFavoritePropertyChange:(NSNotification *)notification {
    ProductViewModel * productViewModel = notification.userInfo[ProductViewModelNotificationProductKey];
    ProductCollectionViewCell * cell = [self cellForProductViewModel:productViewModel];
    if (cell) {
        MAIN_THREAD(cell.favoriteButton.on = productViewModel.favorited);
    }
}

- (ProductCollectionViewCell *)cellForProductViewModel:(ProductViewModel *)productViewModel {
    NSUInteger index = [self.viewModel indexOfProductViewModel:productViewModel];
    ProductCollectionViewCell * cell = nil;
    if (index != NSNotFound) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        cell = (ProductCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    }
    return cell;
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
    layout.sectionInset = UIEdgeInsetsZero;
    return layout;
}

- (void)registerCell {
    UINib * cellNib = [UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
}

@end
