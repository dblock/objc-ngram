//
//  OCNDictionary.m
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//
//

#import "OCNDictionary.h"

@implementation OCNDictionary

+ (instancetype)dictionary
{
    return [[OCNDictionary alloc] init];
}

+ (NSDictionary *)ngramsForString:(NSString *)str
{
    NSMutableDictionary *ngrams = [NSMutableDictionary dictionary];
    return ngrams;
}

@end
