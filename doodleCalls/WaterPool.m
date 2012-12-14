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
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        waterPoolSprite = [CCSprite spriteWithSpriteFrameName: @"pool.png"];
        waterPoolSprite.position = ccp(0,0);
        [self addChild: waterPoolSprite];
        
        CGSize spriteSize = [waterPoolSprite contentSize];
        self.contentSize = spriteSize;
    }
    
    return self;
}

@end
