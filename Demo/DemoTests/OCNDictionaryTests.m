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

beforeEach(^{
    dict = [OCNDictionary dictionary];
});

it(@"creates an instance", ^{
    expect(dict).toNot.beNil();
});

describe(@"ngramsForString", ^{
    pending(@"returns an empty set for an empty string", ^{
        expect([dict ngramsForString:@""]).to.equal(@{});
    });

    pending(@"returns 1-character n-gram", ^{
        NSDictionary *expectedResult = @{ @"a": @"a" };
        expect([dict ngramsForString:@"a"]).to.equal(expectedResult);
    });

    pending(@"returns a 2-character n-gram", ^{
        NSDictionary *expectedResult = @{ @"ab": @"ab" };
        expect([dict ngramsForString:@"ab"]).to.equal(expectedResult);
    });

    it(@"returns a 3-character n-gram", ^{
        NSDictionary *expectedResult = @{ @"abc": @(1 + 1.0f/3) };
        expect([dict ngramsForString:@"abc"]).to.equal(expectedResult);
    });

    it(@"returns a maximum number of n-grams", ^{
        NSDictionary *expectedResult = @{
            @"abc": @(1 + 1.0f/11),
            @"efg": @(2.0f/11),
            @"ijk": @(2.0f/11)
        };
        expect([dict ngramsForString:@"abcdefghijk" withMax:3 andWidth:3]).to.equal(expectedResult);
    });
    
    it(@"returns 3-grams by default", ^{
        NSDictionary *expectedResult = @{
           @"abc": @(1 + 1.0f/4),
           @"bcd": @(2.0f/4)
        };
        expect([dict ngramsForString:@"abcd"]).to.equal(expectedResult);
    });
    
    it(@"returns 9-grams", ^{
        NSDictionary *expectedResult = @{
            @"abcdefghi" : @(1 + 1.0f/10),
            @"bcdefghij" : @(2.0f/10)
        };
        expect([dict ngramsForString:@"abcdefghij" withWidth:9]).to.equal(expectedResult);
    });

    it(@"returns the original string when same length as the n-gram width", ^{
        NSString *s = @"abcdefghij";
        NSDictionary *expectedResult = @{ s : @(1 + 1.0f/s.length) };
        expect([dict ngramsForString:s withWidth:s.length]).to.equal(expectedResult);
    });

    it(@"does not return more than the n-gram size", ^{
        NSDictionary *expectedResult = @{};
        expect([dict ngramsForString:@"abcdefghij" withWidth:12]).to.equal(expectedResult);
    });

    it(@"removes non-alphanumeric characters", ^{
        NSDictionary *expectedResult = @{ @"abc" : @(1 + 1.0f/4), @"bcd" : @(2.0f/4) };
        expect([dict ngramsForString:@"a, b^^%c,d"]).to.equal(expectedResult);
    });
    
});

SpecEnd
