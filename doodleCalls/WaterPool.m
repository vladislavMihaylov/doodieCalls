//
//  WaterPool.m
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterPool.h"


@implementation WaterPool

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
        CCSpriteBatchNode *gameBatchNode = [CCSpriteBatchNode batchNodeWithFile: @"game_atlas.png"];
        [self addChild: gameBatchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        CCSprite *waterPool = [CCSprite spriteWithSpriteFrameName: @"pool.png"];
        waterPool.position = ccp(0,0);
        [self addChild: waterPool];
    }
    
    return self;
}

@end
