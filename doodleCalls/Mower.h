//
//  Mower.h
//  doodleCalls
//
//  Created by Vlad on 06.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface Mower : CCLayer
{
    GameLayer *gameLayer;
    
    CCSprite *sprite;
    
    NSInteger pointIndex;
    NSInteger pointNumber;
    
    NSInteger stepsCount;
    NSInteger lenghtOfStepX;
    NSInteger lenghtOfStepY;
    
    NSArray *pointsArray;
    
}

+ (Mower *) create;

- (void) moveWithPath: (NSArray *) points;

@property (nonatomic, assign) GameLayer *gameLayer;

@end
