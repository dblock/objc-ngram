//
//  OCNObjectScore
//  objc-ngram
//
//  Created by Daniel Doubrovkine on 2/26/14.
//
//

#import <Foundation/Foundation.h>

@interface OCNObjectScore : NSObject
@property(nonatomic, readonly) id object;
@property(nonatomic, assign) CGFloat score;

- (id) initWithObject:(id)object andScore:(CGFloat)score;
@end
