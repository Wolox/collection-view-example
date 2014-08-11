//
//  Product.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithDictionary:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _productId = attributes[@"id"];
        _name = attributes[@"name"];
        _price = [attributes[@"price"] unsignedIntegerValue];
        _imageURL = [NSURL URLWithString:attributes[@"image_url"]];
        _productDescription = attributes[@"description"];
    }
    return self;
}

@end
