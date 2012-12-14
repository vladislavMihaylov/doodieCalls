//
//  Poo.m
//  doodleCalls
//
//  Created by Vlad on 11.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Poo.h"
#import "Common.h"

@implementation Poo

@synthesize tap;
@synthesize collised;

+ (Poo *) create
{
    Poo *poo = [[[Poo alloc] init] autorelease];
    
    return poo;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"game_atlas.plist"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"steam"]];
        
        pooSprite = [CCSprite spriteWithSpriteFrameName: @"poo.png"];
        
        steamSprite = [CCSprite spriteWithSpriteFrameName: @"steam0.png"];
        steamSprite.position = ccp(pooSprite.position.x, pooSprite.position.y + 30);
        
        [self addChild: pooSprite];
        [self addChild: steamSprite];
        
        [self playSteamAnimation];
        
        tap = NO;
        collised = NO; // не нужный параметр;
        
        CGSize spriteSize = [pooSprite contentSize];
        self.contentSize = spriteSize;
    }
    
    return self;
}

- (void) playSteamAnimation
{
    [steamSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"steam"]
                                 ]
             ]
     ];
}

- (BOOL) isTapped: (CGPoint) location
{
    float Ax = pooSprite.contentSize.width / 2;
    float Ay = pooSprite.contentSize.height / 2;
    float Tx = fabs(self.position.x - location.x);
    float Ty = fabsf(self.position.y - location.y);
    
    BOOL result = Tx <= Ax && Ty <= Ay;
    
    return result;
}

@end
