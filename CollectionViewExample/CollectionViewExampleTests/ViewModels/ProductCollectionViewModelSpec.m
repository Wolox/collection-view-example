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
#import "FetchAllProductFetcher.h"

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
    [products addObject:product1];
    [products addObject:product2];
    [products addObject:product3];
    
    productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts:products andRepository:repository];
});

afterEach(^{
    repository = nil;
    products = nil;
    productCollectionViewModel = nil;
});



describe(@"#loadWithErrorHandler", ^{
    context(@"when loadWithErrorHandler: was not called", ^{
        __block ProductCollectionViewModel * originalProductCollectionViewModel = nil;
        
        beforeEach(^{
            originalProductCollectionViewModel = productCollectionViewModel;
            productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts:nil andRepository:repository];
        });
        
        afterEach(^{
            productCollectionViewModel = originalProductCollectionViewModel;
            originalProductCollectionViewModel = nil;
        });
        
        it(@"the products are nil", ^{
            expect([productCollectionViewModel productsCount]).to.equal(0);
        });
        
    });
    context(@"when is called with a handler", ^{
        context(@"when no error while loading", ^{
            it(@"loads the products", ^{
                [productCollectionViewModel loadWithErrorHandler:^(NSError * error) {
                    expect(error).to.beNil;
                }];
                expect([productCollectionViewModel productsCount]).to.equal([products count]);
                
            });
        });
        context(@"when an error occur while loading", ^{
            
            __block id<ProductFetcher> mockProductFetcher;
            __block id<ProductFetcher> originalProductFetcher;
            __block NSError * error;
            
            beforeEach(^{
                error = [NSError errorWithDomain:@"foo" code:0 userInfo:nil];
                mockProductFetcher = mockProtocol(@protocol(ProductFetcher));
                originalProductFetcher = productCollectionViewModel.productFetcher;
                productCollectionViewModel.productFetcher = mockProductFetcher;
            });
            
            afterEach(^{
                error = nil;
                mockProductFetcher = nil;
                productCollectionViewModel.productFetcher = originalProductFetcher;
            });
            
            it(@"doesn't load the products", ^AsyncBlock{
                [productCollectionViewModel loadWithErrorHandler:^(NSError * error) {
                    expect(error).notTo.beNil;
                    done();
                }];
                
                MKTArgumentCaptor * blockCaptor = [[MKTArgumentCaptor alloc] init];
                [MKTVerify(mockProductFetcher) fetchProductsWithHandler:blockCaptor.capture];
                void(^block)(NSError *, NSArray *) = blockCaptor.value;
                block(error, nil);
            });
        });
        
    });
});

describe(@"#addProductViewModel:", ^{
    context(@"when the product isn't added", ^{
        it(@"adds the product", ^{
            ProductViewModel * productVM = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
            NSInteger countBefore = [productCollectionViewModel productsCount];
            [productCollectionViewModel addProductViewModel:productVM];
            expect([productCollectionViewModel productsCount]).to.equal(countBefore+1);
        });
    });
    context(@"when the product is already added", ^{
        it(@"it adds it again", ^{
            ProductViewModel * productVM = [productCollectionViewModel productAtIndex:0];
            NSInteger countBefore = [productCollectionViewModel productsCount];
            [productCollectionViewModel addProductViewModel:productVM];
            expect([productCollectionViewModel productsCount]).to.equal(countBefore+1);
        });
    });
});

describe(@"#removeProductViewModel:", ^{
    context(@"when the product is included", ^{
        
        __block ProductViewModel * productViewModel = nil;
        
        beforeEach(^{
            productViewModel = [productCollectionViewModel productAtIndex:0];
        });
        
        afterEach(^{
            productViewModel = nil;
        });
        
        it(@"removes the product", ^{
            NSInteger countBefore = [productCollectionViewModel productsCount];
            [productCollectionViewModel removeProductViewModel:productViewModel];
            expect([productCollectionViewModel productsCount]).to.equal(countBefore-1);
        });
    });
    context(@"when the product isn't included", ^{
        
        __block ProductViewModel * productViewModel = nil;
        
        beforeEach(^{
            productViewModel = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
        });
        
        afterEach(^{
            productViewModel = nil;
        });
        
        it(@"does nothing", ^{
            expect(^{[productCollectionViewModel removeProductViewModel:productViewModel];}).notTo.raiseAny();
        });
    });
});

describe(@"#productAtIndex:", ^{
    context(@"when invalid index is passed", ^{
        it(@"error expected", ^{
            expect(^{[productCollectionViewModel productAtIndex:[products count]+1 ];}).to.raise(@"NSRangeException");
        });
    });
    
    context(@"when valid index is passed", ^{
        it(@"returns a valid product", ^{
            expect([productCollectionViewModel productAtIndex:0 ]).to.beInstanceOf([ProductViewModel class]);
        });
    });
});

describe(@"#productsCount", ^{
    context(@"when products list is empty", ^{
        
        __block ProductCollectionViewModel * originalProductCollectionViewModel;
        
        beforeEach(^{
            originalProductCollectionViewModel = productCollectionViewModel;
            productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts:nil andRepository:repository];
        });
        
        afterEach(^{
            productCollectionViewModel = originalProductCollectionViewModel;
            originalProductCollectionViewModel = nil;
        });
        
        it(@"returns zero", ^{
            expect([productCollectionViewModel productsCount]).to.equal(0);
        });
    });
    context(@"when product list isn't empty", ^{
        it(@"returns amount of products", ^{
            expect([productCollectionViewModel productsCount]).to.equal([products count]);
        });
    });
});

describe(@"#indexOfProductViewModel:", ^{
    context(@"when product list is empty", ^{
        __block ProductCollectionViewModel * originalProductCollectionViewModel = nil;
        __block ProductViewModel * productViewModel = nil;
        
        beforeEach(^{
            originalProductCollectionViewModel = productCollectionViewModel;
            productCollectionViewModel = [[ProductCollectionViewModel alloc] initWithProducts:nil andRepository:repository];
            productViewModel = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
        });
        
        afterEach(^{
            productViewModel = nil;
            productCollectionViewModel = originalProductCollectionViewModel;
            originalProductCollectionViewModel = nil;
        });

        it(@"don't find product", ^{
            expect([productCollectionViewModel indexOfProductViewModel:productViewModel]).to.equal(NSNotFound);
        });
    });
    context(@"when the product list has products", ^{
        context(@"when the product is included", ^{
            __block ProductViewModel * productViewModel = nil;
            
            beforeEach(^{
                productViewModel = [[ProductViewModel alloc] initWithProduct:[products objectAtIndex:0] andRepository:repository];
            });
            
            afterEach(^{
                productViewModel = nil;
            });
            
            it(@"return the position", ^{
                expect([productCollectionViewModel indexOfProductViewModel:productViewModel]).notTo.equal(0);
            });
        });
        context(@"when the product isn't included", ^{
            __block ProductViewModel * productViewModel = nil;
            
            beforeEach(^{
                productViewModel = [[ProductViewModel alloc] initWithProduct:notAddedProduct andRepository:repository];
            });
            
            afterEach(^{
                productViewModel = nil;
            });
            
            it(@"don't find product", ^{
                expect([productCollectionViewModel indexOfProductViewModel:productViewModel]).to.equal(NSNotFound);
            });
        });
    });
});

SpecEnd
