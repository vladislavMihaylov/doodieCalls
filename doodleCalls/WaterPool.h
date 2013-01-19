//
//  WaterPool.h
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Ball;
@class GameLayer;

@interface WaterPool : CCNode
{
    GameLayer *gameLayer;
    
    CCSprite *waterPoolSprite;
}

+ (WaterPool *) create;

- (void) checkCollisionWithPoint: (Ball *) ball;

@property (nonatomic, assign) GameLayer *gameLayer;

@end
