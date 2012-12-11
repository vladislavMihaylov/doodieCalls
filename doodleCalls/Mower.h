//
//  Mower.h
//  doodleCalls
//
//  Created by Vlad on 06.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

typedef enum
{
    right,
    left,
    down,
    up,
} Direction;

@interface Mower : CCLayer
{
    GameLayer *gameLayer;
    
    CCSprite *sprite;
    
    Direction direction;
    
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
@property (nonatomic, assign) Direction direction;

@end
