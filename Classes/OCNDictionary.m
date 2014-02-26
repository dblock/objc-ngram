//
//  OCNDictionary.m
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//  This is heavily inspired from https://github.com/artsy/mongoid_fulltext
//

#import "OCNDictionary.h"

const NSInteger defaultMax = -1;
const NSInteger defaultWidth = 3;

@implementation OCNDictionary

+ (instancetype)dictionary
{
    return [[OCNDictionary alloc] init];
}

/*
 Returns the number of ngrams to extract given a particular string length.
 If we can't afford to extract all ngrams, step over the string in evenly spaced strides to extract ngrams.
 For example, to extract 3 3-letter ngrams from 'abcdefghijk', we'd want to extract 'abc', 'efg', and 'ijk'.
 */
- (NSInteger) stepSizeForLen:(NSInteger)length withMax:(NSInteger)max andWidth:(NSInteger)width
{
    if (max > 0) {
        return MAX(1.0, (NSInteger) (0.5 + (CGFloat) length/max));
    } else {
        return 1;
    }
}

- (NSDictionary *)ngramsForString:(NSString *)str
{
    return [self ngramsForString:str withMax:defaultMax andWidth:defaultWidth];
}

- (NSDictionary *)ngramsForString:(NSString *)str withWidth:(NSInteger)width
{
    return [self ngramsForString:str withMax:defaultMax andWidth:width];
}

/*
 Remove any non-alphanumeric characters.
 Override for a different transformation.
 */
- (NSString *)filterString:(NSString *)str
{
    return [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

/*
 Returns a dictionary of n-grams and their scores.
 
 @param str String to return n-grams for.
 @param max Maximum number of n-grams to return.
 @param width Width (the number n) of each n-gram.
 */
- (NSDictionary *)ngramsForString:(NSString *)str withMax:(NSInteger)max andWidth:(NSInteger)width
{
    str = [self filterString:str];
    NSMutableDictionary *ngrams = [NSMutableDictionary dictionary];
    NSInteger stepSize = [self stepSizeForLen:str.length withMax:max andWidth:width];
    NSInteger stepMax = str.length - width;
    if (stepMax >= 0) {
        for (int step = 0; step <= stepMax; step += stepSize) {
            // Assigning scores to ngrams with the square root-based scoring function
            // and multiplying scores of matching ngrams together yields a score function that has the
            // property that score(x,y) > score(x,z) for any string z containing y and score(x,y) > score(x,z)
            // for any string z contained in y.
            CGFloat score = (step == 0) ? 1 + 1.0f / str.length : 2.0f / str.length;
            NSInteger rangeWidth = fmin(width, str.length - step);
            NSString *substring = [str substringWithRange:NSMakeRange(step, rangeWidth)];
            [ngrams setObject:@(score) forKey:substring];
        }
    }
    return ngrams;
}

@end
