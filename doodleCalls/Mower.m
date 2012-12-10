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

@synthesize gameLayer;

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
        sprite = [CCSprite spriteWithFile: @"Icon.png"]; // спрайт в дальнейшем заменяется анимацией
        
        sprite.anchorPoint = ccp(0.5, 0);
        
        [self addChild: sprite];
        
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"game_atlas.plist"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"smallSide"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"smallDown"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"smallUp"]];
        
    }
    
    return self;
}

/*- (void) moveWithPath: (NSArray *) points
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
                //grassAnchorPoint = ccp(1, 0);
            }
            else
            {
                [self moveLeftAnimation];
                //grassAnchorPoint = ccp(0, 0);
            }
        }
        if(lenghtY != 0)                                              // если движение по вертикали
        {
            timeOfMove = abs(lenghtY / 25);
            
            if(lenghtY > 0)
            {
                [self moveUpAnimation];
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
}*/

- (void) moveWithPath: (NSArray *) points
{
    if(pointNumber < ((points.count / 2) - 1))
    {
        pointsArray = nil;
        pointsArray = [NSArray arrayWithArray: points];
        
        CGPoint lenght = [self calculateLenghtFromArray: pointsArray];
        
        if(lenght.x != 0)                                              // Если движение по горизонтали
        {
            stepsCount = abs(lenght.x / 25);                           // 25 - ширина спрайта выкошенной земли
            
            if(lenght.x > 0)
            {
                [self moveRightAnimation];
                lenghtOfStepX = 25;
                lenghtOfStepY = 0;
            }
            else
            {
                [self moveLeftAnimation];
                lenghtOfStepX = -25;
                lenghtOfStepY = 0;
            }
        }
        if(lenght.y != 0)                                              // если движение по вертикали
        {
            stepsCount = abs(lenght.y / 25);
            
            if(lenght.y > 0)
            {
                [self moveUpAnimation];
                lenghtOfStepY = 25;
                lenghtOfStepX = 0;
            }
            else
            {
                [self moveDownAnimation];
                lenghtOfStepY = -25;
                lenghtOfStepX = 0;
            }
        }
        
        
        [self doStep];
        
        pointNumber += 1;
        pointIndex += 2;
        
        [pointsArray retain];
        
    }
    else
    {
        pointNumber = 0;
        pointIndex = 0;
        [sprite stopAllActions];
    }
}

- (void) addGrass
{
    CCSprite *grass = [CCSprite spriteWithFile: @"grass0.png"];
    grass.position = ccp(self.position.x, self.position.y);
    grass.anchorPoint = ccp(0.5, 0);
    grass.scaleY = 0.625;
    [gameLayer addChild: grass];
}

- (CGPoint) calculateLenghtFromArray: (NSArray *) points
{
    float currentX = [[points objectAtIndex: pointIndex] floatValue];
    float currentY = [[points objectAtIndex: pointIndex + 1] floatValue];
    
    CGPoint currentPoint = CGPointMake(currentX, currentY);
    
    self.position = currentPoint;
    
    float nextX = [[points objectAtIndex: pointIndex + 2] floatValue];
    float nextY = [[points objectAtIndex: pointIndex + 3] floatValue];
    
    CGPoint nextPoint = CGPointMake(nextX, nextY);
    
    NSInteger lenghtX = nextPoint.x - currentPoint.x;             // Длина пути по оси Х
    NSInteger lenghtY = nextPoint.y - currentPoint.y;             // Длина пути по оси Y
    
    CGPoint lenght = CGPointMake(lenghtX, lenghtY);
    
    return lenght;
}

#pragma mark -
#pragma mark Steps

- (void) doStep
{
    [self runAction:
                [CCSequence actions:
                                [CCMoveTo actionWithDuration: 0.5
                                                    position: ccp(self.position.x + lenghtOfStepX, self.position.y + lenghtOfStepY)],
                                [CCCallFunc actionWithTarget: self
                                                    selector: @selector(checkStepsCount)],
                                nil
                ]
    ];
}


- (void) checkStepsCount
{
    stepsCount--;
    
    [self addGrass];
    
    if(stepsCount)
    {
        [self doStep];
    }
    else
    {
        [self moveWithPath: pointsArray];
    }
}

#pragma mark -
#pragma mark Animations

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
