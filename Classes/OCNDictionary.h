//
//  OCNDictionary.h
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//
//

#import <Foundation/Foundation.h>
#import "OCNObjectScore.h"

@interface OCNDictionary : NSObject

+ (instancetype)dictionary;

/**
 Initialize a dictionary with a n-gram width (the number n in n-gram).
 Default is 3.
 **/
+ (instancetype)dictionaryWithNgramWidth:(NSInteger)width;

/**
 Initialize a dictionary with a n-gram width (the number n in n-gram).
 Default is 3.
 **/
- (id) initWithNgramWidth:(NSInteger)ngramWidth;

/**
 Insert an object into the dictionary.
 
 @param object Object to insert.
 @param key Object key from which to calculate n-grams.

 **/
- (void) addObject:(id)object forKey:(NSString *)key;

/**
 Match objects.
 **/
- (NSArray *)matchObjectsForKey:(NSString *)key;

@end
