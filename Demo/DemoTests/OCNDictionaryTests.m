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

describe(@"default width", ^{
    beforeEach(^{
        dict = [OCNDictionary dictionary];
    });
    
    it(@"creates an instance", ^{
        expect(dict).toNot.beNil();
    });
    
    it(@"adds text and matches results", ^{
        [dict addObject:@"red brown fox" forKey:@"red brown fox"];
        [dict addObject:@"white big bear" forKey:@"white big bear"];
        [dict addObject:@"hiding rabbit" forKey:@"hiding"];
        
        NSArray *results = [dict matchObjectsForKey:@"white fox"];
        
        for (OCNObjectScore *result in results) {
            NSLog(@"'%@' has a score of %f", result.object, result.score);
        }
        
        expect(results.count).to.equal(2);
        OCNObjectScore *bear = results[0];
        expect(bear.object).to.equal(@"white big bear");
        OCNObjectScore *fox = results[1];
        expect(fox.object).to.equal(@"red brown fox");
        expect(bear.score).to.beGreaterThan(fox.score);
    });
});


describe(@"custom width", ^{
    beforeEach(^{
        dict = [OCNDictionary dictionaryWithNgramWidth:4];
    });
    
    it(@"creates an instance", ^{
        expect(dict).toNot.beNil();
    });
    
    it(@"adds text and matches results", ^{
        [dict addObject:@"red brown fox" forKey:@"red brown fox"];
        [dict addObject:@"white big bear" forKey:@"white big bear"];

        NSArray *results = [dict matchObjectsForKey:@"white fox"];
        
        for (OCNObjectScore *result in results) {
            NSLog(@"'%@' has a score of %f", result.object, result.score);
        }
        
        expect(results.count).to.equal(1);
        OCNObjectScore *bear = results[0];
        expect(bear.object).to.equal(@"white big bear");
    });
});

SpecEnd
