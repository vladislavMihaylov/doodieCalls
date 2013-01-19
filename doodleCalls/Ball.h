//
//  Ball.h
//  doodleCalls
//
//  Created by Vlad on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

typedef enum{
    inPool,
    onField,
    inAir,
}BallStatus;

@interface Ball: CCNode
{
    GameLayer *gameLayer;
    
    CCSprite *ballSprite;
    
    BallStatus status;
    float ballTime;
    
    BOOL tap;
}

+ (Ball *) create;

- (NSInteger) getRandomNumberForBall;
- (void) flyToPosition: (CGPoint) point;
- (BOOL) isTapped: (CGPoint) location;

@property (nonatomic, assign) GameLayer *gameLayer;
@property (nonatomic, assign) BallStatus status;
@property (nonatomic, assign) BOOL tap;
@property (nonatomic, assign) float ballTime;

@end
