//
//  OCNDictionary.m
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//  This is heavily inspired from https://github.com/artsy/mongoid_fulltext
//

#import "OCNDictionary.h"
#import "OCNNgramGenerator.h"

@interface OCNDictionary ()
@property(readonly, nonatomic) OCNNgramGenerator *generator;
@property(readonly, nonatomic) NSMapTable *items;
@end

@implementation OCNDictionary

+ (instancetype)dictionary
{
    return [[OCNDictionary alloc] init];
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        _ngramWidth = 3;
        _generator = [[OCNNgramGenerator alloc] init];
        _items = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)addObject:(id)object forKey:(NSString *)key
{
    NSDictionary *ngramsWithScores = [self.generator ngramsForString:key withWidth:self.ngramWidth];
    [ngramsWithScores enumerateKeysAndObjectsUsingBlock:^(NSString *ngram, NSNumber *score, BOOL *stop) {
        NSMapTable *objectsToScores = [self.items objectForKey:ngram];
        if (! objectsToScores) {
            objectsToScores = [NSMapTable strongToStrongObjectsMapTable];
            [self.items setObject:objectsToScores forKey:ngram];
        }
        [objectsToScores setObject:score forKey:object];
    }];
}

- (NSMapTable *)matchObjectsForKey:(NSString *)key
{
    NSMapTable *results = [NSMapTable strongToStrongObjectsMapTable];
    NSDictionary *ngramsWithScores = [self.generator ngramsForString:key withWidth:self.ngramWidth];
    [ngramsWithScores enumerateKeysAndObjectsUsingBlock:^(NSString *ngram, NSNumber *score, BOOL *stop) {
        NSMapTable *objectsToScores = [self.items objectForKey:ngram];
        for (id object in objectsToScores.keyEnumerator) {
            NSNumber *ngramScore = [objectsToScores objectForKey:object];
            NSNumber *currentScore = [results objectForKey:object] ?: @(0);
            currentScore = @(currentScore.floatValue + ngramScore.floatValue);
            [results setObject:currentScore forKey:object];
        }
    }];
    return results;
}

@end
