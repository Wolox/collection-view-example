#import <Kiwi/Kiwi.h>

#import "Product.h"
#import "InMemoryProductRepository.h"
#import "ProductViewModel.h"

SPEC_BEGIN(ProductViewModelSpec)

let(repository, ^{ return [KWMock mockForProtocol:@protocol(ProductRepository)]; });
let(product, ^{ return [[Product alloc] initWithDictionary:@{
                    @"name" : @"test product",
                    @"id" : @"123456",
                    @"price" : @(15099),
                    @"image_url" : @"http://localhost:8080/test.png",
                    @"description" : @"a test description"
}]; });
let(notificationCenter, ^{ return [KWMock mockForClass:[NSNotificationCenter class]]; });
let(productViewModel, ^{
    return [[ProductViewModel alloc] initWithProduct:product
                                          repository:repository
                               andNotificationCenter:notificationCenter];
});

describe(@"#productId", ^{
    
    it(@"is forwarded to the model", ^{
        [[productViewModel.productId should] equal:product.productId];
    });
    
});

describe(@"#name", ^{
    
    it(@"is forwarded to the model", ^{
        [[productViewModel.name should] equal:product.name];
    });
    
});

describe(@"#price", ^{
    
    it(@"formats the price", ^{
        [[productViewModel.price should] equal:@"$150.99"];
    });
    
});

describe(@"#productDescription", ^{
    
    it(@"is forwarded to the model", ^{
        [[productViewModel.productDescription should] equal:product.productDescription];
    });
    
});

describe(@"#favorited", ^{
    
    it(@"is forwarded to the model", ^{
        [[theValue(productViewModel.favorited) should] equal:theValue(product.favorited)];
    });
    
});

describe(@"#image", ^{

    context(@"when loadImageWithHandler: was not called", ^{
    
        specify(^{
            [[productViewModel.image should] beNil];
        });
        
    });
    
    context(@"when loadImageWithHandler: was not called", ^{
        
        beforeEach(^(void){
//            [productViewModel loadImageWithHandler:^(NSError * error, UIImage * image) {
//                
//            }];
        });
        
    });
    
});

describe(@"#setFavorited:withHandler:", ^{
    
    context(@"when favoriting the product", ^{
    
        context(@"when the product has already been favorited", ^{
            
            beforeEach(^{
                product.favorited = YES;
            });
            
            it(@"imediatly calls the handler", ^{
                [productViewModel setFavorited:YES withHandler:^(NSError * error) {
                    [[error should] beNil];
                }];
            });
            
        });
        
        context(@"when the product is not favorited", ^{
            
            beforeEach(^{
                [repository stub:@selector(favoriteProductWithId:withHandler:)];
                [notificationCenter stub:@selector(postNotificationName:object:userInfo:)];
            });
            
            it(@"persists the favorite property", ^{
                SEL selector = @selector(favoriteProductWithId:withHandler:);
                KWCaptureSpy * productIdSpy = [repository captureArgument:selector atIndex:0];
                KWCaptureSpy * handlerSpy = [repository captureArgument:selector atIndex:1];
                [[repository should] receive:selector];
                
                __block typeof(productViewModel) viewModel = productViewModel;
                [productViewModel setFavorited:YES withHandler:^(NSError * error){
                    [[error should] beNil];
                    [[theValue(viewModel.favorited) should] beTrue];
                }];
                
                [[productIdSpy.argument should] equal:product.productId];
                void (^handler)(NSError *) = handlerSpy.argument;
                handler(nil);
            });
            
            it(@"notifies about the property change", ^{
                NSString * notificationName = ProductViewModelProductFavoritePropertyChangedNotification;
                NSDictionary * userInfo = @{ProductViewModelNotificationProductKey: productViewModel};
                [[[notificationCenter should] receive] postNotificationName:notificationName object:productViewModel userInfo:userInfo];
                [productViewModel setFavorited:YES withHandler:^(NSError * error){}];
            });
            
        });
        
    });
    
});

SPEC_END