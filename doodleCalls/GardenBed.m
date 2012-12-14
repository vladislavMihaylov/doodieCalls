//
//  GardenBed.m
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GardenBed.h"


@implementation GardenBed

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
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        gardenBedSprite = [CCSprite spriteWithSpriteFrameName: @"field.png"];
        gardenBedSprite.position = ccp(0,0);
        [self addChild: gardenBedSprite];
        
        CGSize spriteSize = [gardenBedSprite contentSize];
        self.contentSize = spriteSize;
    }
    
    return self;
}

@end
