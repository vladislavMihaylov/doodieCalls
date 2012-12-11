//
//  Kennel.m
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Kennel.h"


@implementation Kennel

+ (Kennel *) create
{
    Kennel *kennel = [[[Kennel alloc] init] autorelease];
    
    return kennel;
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
        
        CCSprite *kennel = [CCSprite spriteWithSpriteFrameName: @"kennel.png"];
        kennel.position = ccp(0,0);
        [self addChild: kennel];
    }
    
    return self;
}

@end
