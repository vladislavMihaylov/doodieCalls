//
//  Mower.h
//  doodleCalls
//
//  Created by Vlad on 06.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Mower : CCLayer
{
    CCSprite *sprite;
    
    NSInteger pointIndex;
    NSInteger pointNumber;
    
    NSArray *pointsArray;
}

+ (Mower *) create;

- (void) moveWithPath: (NSArray *) points;

@end
