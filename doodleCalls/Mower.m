//
//  Mower.m
//  doodleCalls
//
//  Created by Vlad on 06.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Mower.h"
#import "Common.h"


@implementation Mower

+ (Mower *) create
{
    Mower *mower = [[[Mower alloc] init] autorelease];
    
    return mower;
}

- (void) dealloc
{
    [super dealloc];
    [pointsArray release];
}

- (id) init
{
    if(self = [super init])
    {
        sprite = [CCSprite spriteWithFile: @"Icon.png"];
        sprite.position = ccp(0,0);
        [self addChild: sprite];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"game_atlas.plist"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"smallSide"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"smallDown"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"smallUp"]];
    }
    
    return self;
}

- (void) moveWithPath: (NSArray *) points
{
    if(pointNumber < ((points.count / 2) - 1))
    {
        pointsArray = nil;
        pointsArray = [NSArray arrayWithArray: points];
        
        float currentX = [[pointsArray objectAtIndex: pointIndex] floatValue];
        float currentY = [[pointsArray objectAtIndex: pointIndex + 1] floatValue];
        
        CGPoint currentPoint = CGPointMake(currentX, currentY);
        
        self.position = currentPoint;
        
        float nextX = [[pointsArray objectAtIndex: pointIndex + 2] floatValue];
        float nextY = [[pointsArray objectAtIndex: pointIndex + 3] floatValue];
        
        CGPoint nextPoint = CGPointMake(nextX, nextY);
        
        NSInteger lenghtX = nextPoint.x - currentPoint.x;             // Длина пути по оси Х
        NSInteger lenghtY = nextPoint.y - currentPoint.y;             // Длина пути по оси Y
        
        NSInteger timeOfMove;
        
        if(lenghtX != 0)                                              // Если движение по горизонтали
        {
            timeOfMove = abs(lenghtX / 25);                           // 25 - ширина спрайта выкошенной земли
            
            if(lenghtX > 0)
            {
                [self moveRightAnimation];
            }
            else
            {
                [self moveLeftAnimation];
            }
        }
        if(lenghtY != 0)                                              // если движение по вертикали
        {
            timeOfMove = abs(lenghtY / 25);
            
            if(lenghtX > 0)
            {
                [self moveRightAnimation];
            }
            else
            {
                [self moveDownAnimation];
            }
        }
        
        pointNumber += 1;
        pointIndex += 2;
        
        [self runAction:
                    [CCSequence actions:
                                [CCMoveTo actionWithDuration: timeOfMove / 2
                                                    position: nextPoint],
                                [CCCallFunc actionWithTarget: self
                                                    selector: @selector(doNextMove)],
                                nil]
         ];
        
        [pointsArray retain];
        
    }
    else
    {
        pointNumber = 0;
        pointIndex = 0;
        [sprite stopAllActions];
    }
}

- (void) doNextMove
{
    [self moveWithPath: pointsArray];
}

- (void) moveRightAnimation
{
    sprite.scaleX = 1;
    
    [sprite stopAllActions];
    
    [sprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"smallSide"]
                                 ]
             ]
     ];
}

- (void) moveLeftAnimation
{
    sprite.scaleX = -1;
    
    [sprite stopAllActions];
    
    [sprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"smallSide"]
                                 ]
             ]
     ];
}

- (void) moveDownAnimation
{
    sprite.scaleX = 1;
    
    [sprite stopAllActions];
    
    [sprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"smallDown"]
                                 ]
             ]
     ];
}

- (void) moveUpAnimation
{
    sprite.scaleX = 1;
    
    [sprite stopAllActions];
    
    [sprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"smallUp"]
                                 ]
             ]
     ];
}

@end
