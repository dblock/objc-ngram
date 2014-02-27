//
//  OCNObjectScore.m
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//

#import "OCNObjectScore.h"

@implementation OCNObjectScore

- (id) initWithObject:(id)object andScore:(CGFloat)score
{
    self = [super init];
    if (self) {
        _object = object;
        _score = score;
    }
    return self;
}

@end
