//
//  OCNDictionaryTests
//
//  Created by Daniel Doubrovkine on 2/26/14.
//  Copyright (c) 2014 Daniel Doubrovkine. All rights reserved.
//

#define EXP_SHORTHAND
#include <Specta/Specta.h>
#include <Expecta/Expecta.h>
#include <objc-ngram/OCNDictionary.h>

SpecBegin(OCNDictionarySpec)

__block OCNDictionary *dict = nil;

describe(@"dictionary", ^{
    beforeEach(^{
        dict = [OCNDictionary dictionary];
    });
    
    it(@"creates an instance", ^{
        expect(dict).toNot.beNil();
    });
});

describe(@"ngramsForString", ^{
    it(@"returns 3-grams by default", ^{
        expect([OCNDictionary ngramsForString:@"hello world"]).to.equal(@{});
    });
});

SpecEnd
