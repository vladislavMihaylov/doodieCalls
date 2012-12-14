//
//  Rose.m
//  doodleCalls
//
//  Created by Vlad on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Flower.h"
#import "GameLayer.h"

@implementation Flower

@synthesize gameLayer;

+ (Flower *) create
{
    Flower *flower = [[[Flower alloc] init] autorelease];
    
    return flower;
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
        
        flowerSprite = [CCSprite spriteWithSpriteFrameName: @"flower0.png"];
        flowerSprite.anchorPoint = ccp(0.5, 0.2);
        
        [self addChild: flowerSprite];
        
        CGSize spriteSize = [flowerSprite contentSize];
        self.contentSize = spriteSize;
        
        
    }
    
    return self;
}

- (void) updateFlower
{
    type++;
    
    if(type > 4)
    {
        type = 4;
    }
    
    [self removeChild: flowerSprite cleanup: YES];
    
    flowerSprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"flower%i.png", type]];
    flowerSprite.anchorPoint = ccp(0.5, 0.2);
    
    [self addChild: flowerSprite];
}

- (void) onTaped
{
    if(type == 4)
    {
        type = 0;
        [gameLayer addScoreFromFlower];
        
        [self removeChild: flowerSprite cleanup: YES];
        
        flowerSprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"flower%i.png", type]];
        flowerSprite.anchorPoint = ccp(0.5, 0.2);
        
        [self addChild: flowerSprite];
        
    }
}

@end
