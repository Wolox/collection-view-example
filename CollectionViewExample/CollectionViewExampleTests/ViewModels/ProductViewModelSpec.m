#import "SpecHelper.h"

#import "Product.h"
#import "InMemoryProductRepository.h"
#import "ProductViewModel.h"

SpecBegin(ProductViewModel)

    __block id<ProductRepository> repository = nil;
    __block Product * product = nil;
    __block ProductViewModel * productViewModel = nil;

    beforeEach(^{
    
        repository = mockProtocol(@protocol(ProductRepository));
        product = [[Product alloc] initWithDictionary:@{
            @"name" : @"test product",
            @"id" : @"123456",
            @"price" : @(15099),
            @"image_url" : @"http://localhost:8080/test.png",
            @"description" : @"a test description"
        }];
        productViewModel = [[ProductViewModel alloc] initWithProduct:product andRepository:repository];
    
    });

    afterEach(^{
        repository = nil;
        product = nil;
        productViewModel = nil;
    });

    afterAll(^{
        [OHHTTPStubs removeAllStubs];
    });

    describe(@"#productId", ^{
    
        it(@"is forwarded to the model", ^{
            expect(productViewModel.productId).to.equal(product.productId);
        });
    
    });

    describe(@"#name", ^{
    
        it(@"is forwarded to the model", ^{
            expect(productViewModel.name).to.equal(product.name);
        });
    
    });

    describe(@"#price", ^{
    
        it(@"formats the price", ^{
            expect(productViewModel.price).to.equal(@"$150.99");
        });
    
    });

    describe(@"#productDescription", ^{
    
        it(@"is forwarded to the model", ^{
            expect(productViewModel.productDescription).to.equal(product.productDescription);
        });
    
    });

    describe(@"#favorited", ^{
    
        it(@"is forwarded to the model", ^{
            expect(product.favorited).to.equal(product.favorited);
        });
    
    });

    describe(@"#image", ^{

        context(@"when loadImageWithHandler: was not called", ^{
    
            it(@"is is nil", ^{
                expect(productViewModel.image).to.beNil;
            });
        
        });
    
        context(@"when loadImageWithHandler: was called", ^{
            
            __block UIImage * image = nil;
            
            beforeEach(^AsyncBlock{
            
                stubHTTPImageRequest(product.imageURL, OHPathForFileInBundle(@"product-image.jpg", nil));
        
                [productViewModel loadImageWithHandler:^(NSError * error, UIImage * anImage) {
                    image = anImage;
                    done();
                }];
                
            });
            
            afterEach(^{
                image = nil;
            });
        
            it(@"returns the loaded image", ^{
                expect(productViewModel.image).to.equal(image);
                expect(productViewModel.image.size.width).to.equal(1100);
                expect(productViewModel.image.size.height).to.equal(600);
            });
            
        });
        
    });

    describe(@"#setFavorited:withHandler:", ^{
    
        context(@"when favoriting the product", ^{
    
            context(@"when the product has already been favorited", ^{
            
                beforeEach(^{
                    product.favorited = YES;
                });
            
                it(@"imediatly calls the handler", ^AsyncBlock {
                    [productViewModel setFavorited:YES withHandler:^(NSError * error) {
                        expect(error).to.beNil;
                        done();
                    }];
                });
            
            });
        
            context(@"when the product is not favorited", ^{
            
                __block NSNotification * favoriteChangeNotification = nil;
                __block MKTArgumentCaptor * productIdArgument = nil;
                __block MKTArgumentCaptor * handlerArgument = nil;
                
            
                beforeEach(^{
                    NSString * notificationName = ProductViewModelProductFavoritePropertyChangedNotification;
                    NSDictionary * userInfo = @{ProductViewModelNotificationProductKey: productViewModel};
                    favoriteChangeNotification = [NSNotification notificationWithName:notificationName
                                                                               object:productViewModel
                                                                             userInfo:userInfo];
                    productIdArgument = [[MKTArgumentCaptor alloc] init];
                    handlerArgument = [[MKTArgumentCaptor alloc] init];
                    
                });
                
                afterEach(^{
                    favoriteChangeNotification = nil;
                    productIdArgument = nil;
                    handlerArgument = nil;
                });
            
                it(@"persists the favorite property", ^AsyncBlock{
                    __weak typeof(productViewModel) viewModel = productViewModel;
                    [productViewModel setFavorited:YES withHandler:^(NSError * error){
                        expect(error).to.beNil;
                        expect(viewModel.favorited).to.beTruthy;
                        done();
                    }];
                    [MKTVerify(repository) favoriteProductWithId:productIdArgument.capture
                                                     withHandler:handlerArgument.capture];
                    expect(productIdArgument.value).to.equal(productViewModel.productId);
                    ((void (^)(NSError *))handlerArgument.value)(nil);
                });
            
                it(@"notifies about the property change", ^AsyncBlock {
                    void (^handler)(NSError *) = ^(NSError * error){ done(); };
                    
                    expect(^{ [productViewModel setFavorited:YES withHandler:handler]; }).to.notify(favoriteChangeNotification);
                    
                    [MKTVerify(repository) favoriteProductWithId:productIdArgument.capture
                                                     withHandler:handlerArgument.capture];
                    ((void (^)(NSError *))handlerArgument.value)(nil);
                });
                
                context(@"when there is an error favoriting the product", ^{
                
                    __block NSError * repositoryError = nil;
                    
                    beforeEach(^{
                        repositoryError = [NSError errorWithDomain:@"" code:0 userInfo:nil];
                    });
                    
                    afterEach(^{
                        repositoryError = nil;
                    });
                    
                    it(@"returns the favorite property to its previuos value", ^AsyncBlock {
                        __weak typeof(productViewModel) viewModel = productViewModel;
                        [productViewModel setFavorited:YES withHandler:^(NSError * error){
                            expect(error).to.equal(repositoryError);
                            expect(viewModel.favorited).to.beFalsy;
                            done();
                        }];
                        [MKTVerify(repository) favoriteProductWithId:productIdArgument.capture
                                                         withHandler:handlerArgument.capture];
                        ((void (^)(NSError *))handlerArgument.value)(repositoryError);
                    });
                    
                    it(@"notifies about the property change", ^AsyncBlock{
                        void (^handler)(NSError *) = ^(NSError * error){
                            expect(error).to.equal(repositoryError);
                            done();
                        };
                        expect(^{ [productViewModel setFavorited:YES withHandler:handler]; }).to.notify(favoriteChangeNotification);
                        [MKTVerify(repository) favoriteProductWithId:productIdArgument.capture
                                                         withHandler:handlerArgument.capture];
                        ((void (^)(NSError *))handlerArgument.value)(repositoryError);
                    });
                
                });
            
            });
        
        });
    
    });

SpecEnd