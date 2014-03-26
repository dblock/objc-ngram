//
//  OCNNgramGeneratorTests.m
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//  Copyright (c) 2014 Daniel Doubrovkine. All rights reserved.

#include <objc-ngram/OCNNgramGenerator.h>

SpecBegin(OCNNgramGenerator)

__block OCNNgramGenerator *generator = nil;

beforeEach(^{
    generator = [[OCNNgramGenerator alloc] init];
});

describe(@"ngramsForString", ^{
    it(@"returns an empty set for an empty string", ^{
        expect([generator ngramsForString:@"" withWidth:3]).to.equal(@{});
    });
    
    it(@"returns 1-character n-gram", ^{
        NSDictionary *expectedResult = @{ @"a" : @(2.0f) };
        expect([generator ngramsForString:@"a" withWidth:3]).to.equal(expectedResult);
    });
    
    it(@"returns a 2-character n-gram", ^{
        NSDictionary *expectedResult = @{ @"ab" : @(2.0f) };
        expect([generator ngramsForString:@"ab" withWidth:3]).to.equal(expectedResult);
    });
    
    it(@"returns a 3-character n-gram", ^{
        NSDictionary *expectedResult = @{ @"abc": @(1 + 1.0f/3) };
        expect([generator ngramsForString:@"abc" withWidth:3]).to.equal(expectedResult);
    });
    
    it(@"returns a maximum number of n-grams", ^{
        NSDictionary *expectedResult = @{
                                         @"abc": @(1 + 1.0f/11),
                                         @"efg": @(2.0f/11),
                                         @"ijk": @(2.0f/11)
                                         };
        expect([generator ngramsForString:@"abcdefghijk" withMax:3 andWidth:3]).to.equal(expectedResult);
    });
    
    it(@"returns 3-grams by default", ^{
        NSDictionary *expectedResult = @{
                                         @"abc": @(1 + 1.0f/4),
                                         @"bcd": @(2.0f/4)
                                         };
        expect([generator ngramsForString:@"abcd" withWidth:3]).to.equal(expectedResult);
    });
    
    it(@"returns 9-grams", ^{
        NSDictionary *expectedResult = @{
                                         @"abcdefghi" : @(1 + 1.0f/10),
                                         @"bcdefghij" : @(2.0f/10)
                                         };
        expect([generator ngramsForString:@"abcdefghij" withWidth:9]).to.equal(expectedResult);
    });
    
    it(@"returns the original string when same length as the n-gram width", ^{
        NSString *s = @"abcdefghij";
        NSDictionary *expectedResult = @{ s : @(1 + 1.0f/s.length) };
        expect([generator ngramsForString:s withWidth:s.length]).to.equal(expectedResult);
    });
    
    it(@"does not return more than the n-gram size", ^{
        NSDictionary *expectedResult = @{ @"abcdefghij" : @(1 + 1.0f) };
        expect([generator ngramsForString:@"abcdefghij" withWidth:12]).to.equal(expectedResult);
    });
    
    it(@"removes non-alphanumeric characters", ^{
        NSDictionary *expectedResult = @{ @"abc" : @(1 + 1.0f/4), @"bcd" : @(2.0f/4) };
        expect([generator ngramsForString:@"a, b^^%c,d" withWidth:3]).to.equal(expectedResult);
    });
    
    it(@"sums up scores of repeating n-grams", ^{
        NSDictionary *expectedResult = @{ @"aaa" : @(1 + 1.0f/4 + 2.0f/4) };
        expect([generator ngramsForString:@"aaaa" withWidth:3]).to.equal(expectedResult);
    });
});

SpecEnd
