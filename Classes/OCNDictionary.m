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
@property(readonly, assign) NSInteger ngramWidth;
@property(readonly, nonatomic) OCNNgramGenerator *generator;
@property(readonly, nonatomic) NSMapTable *items;
@end

@implementation OCNDictionary

+ (instancetype)dictionary
{
    return [[OCNDictionary alloc] init];
}

+ (instancetype)dictionaryWithNgramWidth:(NSInteger)width
{
    return [[OCNDictionary alloc] initWithNgramWidth:width];
}

- (instancetype) init
{
    return [self initWithNgramWidth:3];
}

- (instancetype) initWithNgramWidth:(NSInteger)ngramWidth
{
    self = [super init];
    if (self) {
        _ngramWidth = ngramWidth;
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

- (NSArray *)matchObjectsForKey:(NSString *)key
{
    NSMapTable *resultsTable = [NSMapTable strongToStrongObjectsMapTable];
    
    NSDictionary *ngramsWithScores = [self.generator ngramsForString:key withWidth:self.ngramWidth];
    [ngramsWithScores enumerateKeysAndObjectsUsingBlock:^(NSString *ngram, NSNumber *score, BOOL *stop) {
        NSMapTable *objectsToScores = [self.items objectForKey:ngram];
        for (id object in objectsToScores.keyEnumerator) {
            NSNumber *ngramScore = [objectsToScores objectForKey:object];
            NSNumber *currentScore = [resultsTable objectForKey:object] ?: @(0);
            currentScore = @(currentScore.floatValue + ngramScore.floatValue);
            [resultsTable setObject:currentScore forKey:object];
        }
    }];
    
    NSMutableArray *resultsArray = [NSMutableArray array];
    
    for (id object in [resultsTable keyEnumerator]) {
        NSNumber *score = [resultsTable objectForKey:object];
        OCNObjectScore *objectScore = [[OCNObjectScore alloc] initWithObject:object andScore:score.floatValue];
        NSUInteger insertIndex = [resultsArray indexOfObject:objectScore
                                     inSortedRange:(NSRange) {0, [resultsArray count]}
                                           options:NSBinarySearchingInsertionIndex
                                             usingComparator:^(OCNObjectScore *lhs, OCNObjectScore *rhs) {
                                                 if (lhs.score > rhs.score) {
                                                     return NSOrderedAscending;
                                                 } else if (lhs.score < rhs.score) {
                                                     return NSOrderedDescending;
                                                 } else {
                                                     return NSOrderedSame;
                                                 }
                                             }];
        [resultsArray insertObject:objectScore atIndex:insertIndex];
    }
    
    return resultsArray;
}

@end
