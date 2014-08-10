//
//  Application.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductRepository;

@interface Application : NSObject

@property(nonatomic) id<ProductRepository> productRepository;

+ (instancetype)sharedInstance;

@end
