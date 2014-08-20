//
//  ProductViewModel.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductViewModel.h"
#import "Product.h"
#import "ProductRepository.h"

NSString * const ProductViewModelProductFavoritePropertyChangedNotification = @"ProductViewModelNotification.Keys.ProductFavoriteChanged";

NSString * const ProductViewModelNotificationProductKey = @"ProductViewModelNotification.Keys.Product";

@interface ProductViewModel ()

@property(readonly, nonatomic) Product * product;
@property(nonatomic) NSString * formattedPrice;
@property(readonly, nonatomic) id<ProductRepository> repository;
@property(readonly, nonatomic) NSNotificationCenter * notificationCenter;

@end

@implementation ProductViewModel

@dynamic productId;
@dynamic name;
@dynamic favorited;
@dynamic productDescription;

- (instancetype)initWithProduct:(Product *)product
                     repository:(id<ProductRepository>)repository
          andNotificationCenter:(NSNotificationCenter *)notificationCenter {
    self = [super initWithTargetObject:product];
    if (self) {
        _product = product;
        _repository = repository;
        _notificationCenter = notificationCenter;
    }
    return self;
}

- (instancetype)initWithProduct:(Product *)product andRepository:(id<ProductRepository>)repository {
    return [self initWithProduct:product repository:repository andNotificationCenter:[NSNotificationCenter defaultCenter]];
}

- (NSString *)price {
    if (!self.formattedPrice) {
        self.formattedPrice = [self formatPrice:self.product.price];
    }
    return self.formattedPrice;
}

- (void)loadImageWithHandler:(ImageHandler)handler {
    if (self.image) {
        handler(nil, self.image);
    } else {
        [self fetchImageWithHandler:handler];
    }
}

- (void)setFavorited:(BOOL)favorited withHandler:(void(^)(NSError *))handler {
    if (favorited == self.product.favorited) {
        handler(nil);
        return;
    }
    
    self.product.favorited = favorited;
    [self notifyProductFavoritePropertyChanged];
    __block typeof(self) this = self;
    [self.repository favoriteProductWithId:self.product.productId withHandler:^(NSError * error) {
        if (error) {
            this.product.favorited = !favorited;
            [self notifyProductFavoritePropertyChanged];
        }
        handler(error);
    }];
}

#pragma mark - Private Methods

- (NSString *)formatPrice:(NSUInteger)price {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [formatter stringFromNumber:@(price / 100.0f)];
}

- (void)fetchImageWithHandler:(ImageHandler)handler {
    ImageFetcher * fetcher = [[ImageFetcher alloc] initWithImageURL: self.product.imageURL];
    [fetcher fetchImageWithHandler: ^(NSError * error, UIImage * image) {
        if (!error) {
            _image = image;
        }
        handler(error, self.image);
    }];
}

- (void)notifyProductFavoritePropertyChanged {
    [self.notificationCenter postNotificationName:ProductViewModelProductFavoritePropertyChangedNotification
                                           object:self
                                         userInfo:@{ProductViewModelNotificationProductKey:self}];
}

@end
