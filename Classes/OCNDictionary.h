//
//  OCNDictionary.h
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//
//

#import <Foundation/Foundation.h>

@interface OCNDictionary : NSObject
/**
 Size of each n-gram.
 **/
@property(nonatomic, assign) NSInteger ngramWidth;

+ (instancetype)dictionary;

/**
 Insert an object into the dictionary.
 
 @param object Object to insert.
 @param key Object key from which to calculate n-grams.

 **/
- (void) addObject:(id)object forKey:(NSString *)key;

/**
 Match objects.
 **/
- (NSMapTable *)matchObjectsForKey:(NSString *)key;

@end
