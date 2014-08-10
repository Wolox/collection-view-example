//
//  ProductViewModel.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductViewModel.h"
#import "Product.h"

@interface ProductViewModel ()

@property(readonly, nonatomic) Product * product;
@property(nonatomic) NSString * formattedPrice;

@end

@implementation ProductViewModel

@dynamic name;

- (instancetype)initWithProduct:(Product *)product {
    self = [super initWithTargetObject:product];
    if (self) {
        _product = product;
    }
    return self;
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

@end
