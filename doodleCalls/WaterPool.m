//
//  WaterPool.m
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterPool.h"
#import "Ball.h"
#import "GameLayer.h"

@implementation WaterPool

@synthesize gameLayer;

+ (WaterPool *) create
{
    WaterPool *waterPool = [[[WaterPool alloc] init] autorelease];
    
    return waterPool;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        waterPoolSprite = [CCSprite spriteWithSpriteFrameName: @"pool.png"];
        [self addChild: waterPoolSprite];
        
        CGSize spriteSize = [waterPoolSprite contentSize];
        self.contentSize = spriteSize;
    }
    
    return self;
}

- (void) checkCollisionWithPoint: (Ball *) ball
{
   
    
    float Ax = self.contentSize.width / 2;
    float Ay = self.contentSize.height / 2;
    float Tx = fabs(self.position.x - ball.position.x);
    float Ty = fabsf(self.position.y - ball.position.y);
    
    BOOL result = Tx <= Ax && Ty <= Ay;
    
    if(result && ball.tag == self.tag)
    {
        [gameLayer returnBall: ball ToPool: self];
    }
    else
    {
        [gameLayer returnBallToField: ball];
    }
}

@end
