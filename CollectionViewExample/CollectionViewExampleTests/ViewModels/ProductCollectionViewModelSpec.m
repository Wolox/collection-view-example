//
//  ProductCollectionViewModelSpec.m
//  CollectionViewExample
//
//  Created by Tomás Mehdi on 10/20/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "SpecHelper.h"
#import "ProductCollectionViewModel.h"
#import "ProductFactory.h"
#import "Product.h"
#import "ProductViewModel.h"

SpecBegin(ProductCollectionViewModel)

__block NSMutableArray * products = nil;
__block id<ProductRepository> repository = nil;
__block ProductCollectionViewModel * productCollectionViewModel = nil;
__block ProductFactory * productFactory = nil;
__block Product * notAddedProduct = nil;

beforeEach(^{
    
    repository = mockProtocol(@protocol(ProductRepository));
    productFactory = [ProductFactory sharedFactory];
    
    Product * product1 = [productFactory createProduct];
    Product * product2 = [productFactory createProduct];
    Product * product3 = [productFactory createProduct];
    notAddedProduct = [productFactory createProduct];
    
    products = [[NSMutableArray alloc] init];
    [products addObject: product1];
    [products addObject: product2];
    [products addObject: product3];
    
    productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts: products andRepository: repository];
});

afterEach(^{
    repository = nil;
    products = nil;
    productCollectionViewModel = nil;
});



describe(@"#loadWithErrorHandler", ^{
    context(@"when loadWithErrorHandler: was not called", ^{
        it(@"Products is is nil", ^{
            expect([productCollectionViewModel productsCount]).to.equal(0);
        });
        
    });
    context(@"Is called with a handler", ^{
        context(@"No error while loading", ^{
            it(@"Load the products", ^AsyncBlock{
                [productCollectionViewModel loadWithErrorHandler:^(NSError * error) {
                    NSLog(@"Test: Error loading products");
                    done();
                }];
                expect([productCollectionViewModel productsCount]).to.beGreaterThanOrEqualTo(1);
                
            });
        });
        context(@"Error while loading", ^{
            it(@"Don't load the products", ^AsyncBlock{
                [productCollectionViewModel loadWithErrorHandler:^(NSError * error) {
                    NSLog(@"Test: Error loading products");
                    done();
                }];
                expect([productCollectionViewModel productsCount]).to.equal(0);
                
            });
        });
        
    });
});

describe(@"#addProductViewModel:", ^{
    context(@"The product isn't added", ^{
        it(@"Adds the product", ^{
            ProductViewModel * productVM = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
            NSInteger countBefore = [productCollectionViewModel productsCount];
            [productCollectionViewModel addProductViewModel:productVM];
            expect([productCollectionViewModel productsCount]).to.equal(countBefore+1);
        });
    });
    context(@"The product is already added", ^{
        it(@"It adds it again", ^{
            ProductViewModel * productVM = [productCollectionViewModel productAtIndex:0];
            NSInteger countBefore = [productCollectionViewModel productsCount];
            [productCollectionViewModel addProductViewModel:productVM];
            expect([productCollectionViewModel productsCount]).to.equal(countBefore+1);
        });
    });
});

describe(@"#removeProductViewModel:", ^{
    context(@"The product is included", ^{
        it(@"Removes the product", ^{
            ProductViewModel * productVM = [productCollectionViewModel productAtIndex:0];
            NSInteger countBefore = [productCollectionViewModel productsCount];
            [productCollectionViewModel removeProductViewModel:productVM];
            expect([productCollectionViewModel productsCount]).to.equal(countBefore-1);
        });
    });
    context(@"The product isn't included", ^{
        it(@"Does nothing", ^{
            ProductViewModel * productVM = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
            expect(^{[productCollectionViewModel removeProductViewModel:productVM];}).notTo.raiseAny();
        });
    });
});

describe(@"#productAtIndex:", ^{
    context(@"Invalid index is passed", ^{
        it(@"Error expected", ^{
            expect(^{[productCollectionViewModel productAtIndex: [products count]+1 ];}).to.raise(@"NSRangeException");
        });
    });
    
    context(@"Valid index is passed", ^{
        it(@"Return valid product", ^{
            expect([productCollectionViewModel productAtIndex: 0 ]).to.beInstanceOf([ProductViewModel class]);
        });
    });
});

describe(@"#productsCount", ^{
    context(@"Empty products list", ^{
        it(@"returns zero", ^{
            productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts: nil andRepository: repository];
            expect([productCollectionViewModel productsCount]).to.equal(0);
        });
    });
    context(@"Filled products list", ^{
        it(@"Returns amount of products", ^{
            expect([productCollectionViewModel productsCount]).to.equal([products count]);
        });
    });
});

describe(@"#indexOfProductViewModel:", ^{
    context(@"Product list is empty", ^{
        it(@"Don't find product", ^{
            productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts: nil andRepository: repository];
            ProductViewModel * productVM = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
            expect([productCollectionViewModel indexOfProductViewModel:productVM]).to.equal(NSNotFound);
        });
    });
    context(@"Product list if filled", ^{
        context(@"Product is included", ^{
            it(@"Return the position", ^{
                ProductViewModel * productVM = [[ProductViewModel alloc] initWithProduct:[products objectAtIndex:0] andRepository:repository];
                expect([productCollectionViewModel indexOfProductViewModel:productVM]).notTo.equal(0);
            });
        });
        context(@"Product isn't included", ^{
            it(@"Don't find product", ^{
                ProductViewModel * productVM = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
                expect([productCollectionViewModel indexOfProductViewModel:productVM]).to.equal(NSNotFound);
            });
        });
    });
});

SpecEnd
