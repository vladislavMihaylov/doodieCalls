//
//  GardenBed.m
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GardenBed.h"


@implementation GardenBed

@synthesize gardenBedSprite;

+ (GardenBed *) create
{
    GardenBed *gardenBed = [[[GardenBed alloc] init] autorelease];
    
    return gardenBed;
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
        
        gardenBedSprite = [CCSprite spriteWithSpriteFrameName: @"field.png"];
        gardenBedSprite.position = ccp(0,0);
        [gameBatchNode addChild: gardenBedSprite];
    }
    
    return self;
}

@end
