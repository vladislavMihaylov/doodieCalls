//
//  Mower.m
//  doodleCalls
//
//  Created by Vlad on 06.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Mower.h"
#import "Common.h"
#import "Settings.h"

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
        NSInteger curMower = [Settings sharedSettings].currentMower;
        prefix = @"";
        
        if(curMower == 0)
        {
            prefix = @"small";
        }
        else if(curMower == 1)
        {
            prefix = @"large";
        }
        else if(curMower == 2)
        {
            prefix = @"truck";
        }
        else
        {
            prefix = @"jet";
        }
        
        sprite = [CCSprite spriteWithFile: @"Icon.png"]; // спрайт в дальнейшем заменяется анимацией
        
        sprite.anchorPoint = ccp(0.5, 0);
        
        [self addChild: sprite];
        
        CGSize spriteSize = [sprite contentSize];
        self.contentSize = spriteSize;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"game_atlas.plist"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"%@Side", prefix]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"%@Down", prefix]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"%@smallUp", prefix]];
        
    }
    
    return self;
}

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
        [gameLayer succeedGame];
    }
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
    float newPosX = self.position.x + lenghtOfStepX;
    float newPosY = self.position.y + lenghtOfStepY;
    
    [self runAction:
                [CCSequence actions:
                                [CCMoveTo actionWithDuration: 0.5
                                                    position: ccp(newPosX, newPosY)],
                                [CCCallFunc actionWithTarget: self
                                                    selector: @selector(checkStepsCount)],
                                nil
                ]
    ];
}


- (void) checkStepsCount
{
    stepsCount--;
    
    //[self addGrass];
    [gameLayer addGrassToPoint: ccp(self.position.x, self.position.y)];
    
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
                                        [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"%@Side", prefix]]
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
                                        [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"%@Side", prefix]]
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
                                        [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"%@Down", prefix]]
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
                                        [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"%@Up", prefix]]
                                 ]
             ]
     ];
}

@end
