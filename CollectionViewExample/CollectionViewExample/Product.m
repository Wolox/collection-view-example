//
//  Product.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithName:(NSString *)name price:(NSUInteger)price andImageURL:(NSURL *)imageURL {
    self = [super init];
    if (self) {
        _name = name;
        _price = price;
        _imageURL = imageURL;
    }
    return self;
}

@end
