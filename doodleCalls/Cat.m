//
//  Cat.m
//  doodleCalls
//
//  Created by Vlad on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cat.h"
#import "Common.h"

@implementation Cat

@synthesize isRun;

+ (Cat *) create
{
    Cat *cat = [[[Cat alloc] init] autorelease];
    
    return cat;
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
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"cat_down_"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"cat_up_"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"cat_left_"]];
        
        catSprite = [CCSprite spriteWithSpriteFrameName: @"cat_down_1.png"];
        catSprite.anchorPoint = ccp(0.5, 0.05);
        
        [self addChild: catSprite];
        
        CGSize spriteSize = [catSprite contentSize];
        self.contentSize = spriteSize;
        
        isRun = NO;
    }
    
    return self;
}

- (void) walkFromPoint: (CGPoint) point andDirection: (NSInteger) direction
{
    self.position = point;
    
    if(direction == 0)
    {
        [self runAction: [CCMoveTo actionWithDuration: 8 position: ccp( 580 , point.y)]];
        [self moveRightAnimation];
    }
    if(direction == 1)
    {
        [self runAction: [CCMoveTo actionWithDuration: 8 position: ccp( -100 , point.y)]];
        [self moveLeftAnimation];
    }
}

- (void) runToPoint: (CGPoint) escapePoint andDirection: (NSInteger) direction
{
    [self runAction:
                [CCSequence actions:
                                [CCMoveTo actionWithDuration: 3
                                                    position: escapePoint],
                                [CCCallFunc actionWithTarget: self selector: @selector(switchRunStatus)],
                                nil
                ]
    ];
    
    if(direction == 0)
    {
        [self moveLeftAnimation];
    }
    if(direction == 1)
    {
        [self moveDownAnimation];
    }
    if(direction == 2)
    {
        [self moveRightAnimation];
    }
}

- (void) switchRunStatus
{
    self.position = ccp(-100, -100);
    self.isRun = NO;
}

#pragma mark -
#pragma mark Animations

- (void) moveRightAnimation
{
    catSprite.scaleX = -1;
    
    [catSprite stopAllActions];
    
    [catSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"cat_left_"]
                                 ]
             ]
     ];
}

- (void) moveLeftAnimation
{
    catSprite.scaleX = 1;
    
    [catSprite stopAllActions];
    
    [catSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"cat_left_"]
                                 ]
             ]
     ];
}

- (void) moveDownAnimation
{
    catSprite.scaleX = 1;
    
    [catSprite stopAllActions];
    
    [catSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"cat_down_"]
                                 ]
             ]
     ];
}

- (void) moveUpAnimation
{
    catSprite.scaleX = 1;
    
    [catSprite stopAllActions];
    
    [catSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"cat_up_"]
                                 ]
             ]
     ];
}

@end
