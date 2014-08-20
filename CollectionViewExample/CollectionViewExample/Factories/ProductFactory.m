//
//  ProductFactory.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductFactory.h"
#import "NSArray+Random.h"

@interface ProductFactory ()

@property(nonatomic) NSArray * imageURLs;
@property(nonatomic) NSArray * names;
@property(nonatomic) NSArray * prices;
@property(nonatomic) NSUInteger ids;

@end

@implementation ProductFactory

+ (instancetype)sharedFactory {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ids = 0;
        _imageURLs = @[
            @"http://www.botasdejugadores.com/wp-content/uploads/2014/03/nike-tiempo-legend-5-rojas-blancas-51.jpg",
            @"http://2.bp.blogspot.com/-R0T0bXmBCOE/UjbNV9n91aI/AAAAAAAAJHQ/nqg2eNQALZQ/s738/NikeTiempo-Legend-Hi-Vis-Boot-2.jpg",
            @"http://www.yourmomhatesthis.com/images/Dc-Shoes-1a4.png"
        ];
        _names = @[
            @"Botines Nike Tiempo",
            @"Botines Nike T90",
            @"Zapatillas"
        ];
        _prices = @[
            @(70000),
            @(54999)
        ];
    }
    return self;
}

- (Product *)createProduct {
    NSDictionary * attributes = @{
      @"id" : [NSString stringWithFormat:@"%lu", (unsigned long)++self.ids],
      @"name" : [self.names randomObject],
      @"price" : [self.prices randomObject],
      @"image_url" : [self.imageURLs randomObject],
      @"description" : @"Random description for a random product. I am to lazy to initialize another array :-P"
    };
    return [[Product alloc] initWithDictionary:attributes];
}

@end
