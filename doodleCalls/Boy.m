//
//  Boy.m
//  doodleCalls
//
//  Created by Vlad on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Boy.h"
#import "Common.h"

@implementation Boy

+ (Boy *) create
{
    Boy *boy = [[[Boy alloc] init] autorelease];
    
    return boy;
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
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"ballboy"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"throwball"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"withoutballboy"]];
        
        boySprite = [CCSprite spriteWithSpriteFrameName: @"ballboy0.png"];
        boySprite.anchorPoint = ccp(0.5, 0.3);
        
        [self addChild: boySprite];
        
        [self playBallBoyAnimation];
        
        CGSize spriteSize = [boySprite contentSize];
        self.contentSize = spriteSize;
    }
    
    return self;
}

- (void) playBallBoyAnimation
{
    [boySprite stopAllActions];
    
    [boySprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"ballboy"]
                                 ]
             ]
     ];
}

- (void) playThrowBallBoyAnimation
{
    [boySprite stopAllActions];
    
    [boySprite runAction: [CCSequence actions: 
                    [CCAnimate actionWithAnimation:
                            [[CCAnimationCache sharedAnimationCache] animationByName: @"throwball"]
                     ],
                     [CCCallFunc actionWithTarget: self selector: @selector(playWithoutBallBoyAnimation)],
                     nil]
     
     ];
}

- (void) playWithoutBallBoyAnimation
{
    [boySprite stopAllActions];
    
    [boySprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"withoutballboy"]
                                 ]
             ]
     ];
}


@end
