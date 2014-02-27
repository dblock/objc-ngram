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

it(@"adds text and matches results", ^{
    [dict addObject:@"fox" forKey:@"red brown fox"];
    [dict addObject:@"bear" forKey:@"white big bear"];
    [dict addObject:@"rabbit" forKey:@"hiding"];
    
    NSMapTable *results = [dict matchObjectsForKey:@"white fox"];
    expect(results.count).to.equal(2);
    expect([results objectForKey:@"bear"]).to.beGreaterThan([results objectForKey:@"fox"]);
});

SpecEnd
