//
//  Product.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property(readonly, nonatomic) NSString * productId;
@property(readonly, nonatomic) NSString * name;
@property(readonly, nonatomic) NSUInteger price;
@property(readonly, nonatomic) NSURL * imageURL;
@property(readonly, nonatomic) NSString * productDescription;
@property(nonatomic) BOOL favorited;

- (instancetype)initWithDictionary:(NSDictionary *)attributes;

@end
