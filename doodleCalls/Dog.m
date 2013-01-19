//
//  Dog.m
//  doodleCalls
//
//  Created by Vlad on 12.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Dog.h"
#import "GameConfig.h"
#import "GameLayer.h"
#import "Common.h"

#import "Poo.h"

@implementation Dog

@synthesize gameLayer;
@synthesize isRun;

+ (Dog *) create
{
    Dog *dog = [[[Dog alloc] init] autorelease];
    
    return dog;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        dogSprite = [CCSprite spriteWithFile: @"Icon.png"];
        dogSprite.anchorPoint = ccp(0.5, 0.2);
        [self addChild: dogSprite];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"game_atlas.plist"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"dog_down_"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"dog_up_"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"dog_left_"]];
        
        [Common loadAnimationWithPlist: @"moveAnimation" andName: [NSString stringWithFormat: @"dog_right_"]];
        
        [self schedule: @selector(poo) interval: 5];
        
        CGSize spriteSize = [dogSprite contentSize];
        self.contentSize = spriteSize;
        
        self.isRun = NO;
    }
    
    return self;
}

- (void) walk
{
    NSInteger minX = 50;
    NSInteger maxX = 350;
    
    NSInteger minY = 25;
    NSInteger maxY = 225;
    
    NSInteger direction = arc4random() % 4;
    NSInteger distance;
    NSInteger countPointsInDistance;
    NSInteger currentDistance;
    CGPoint dogPoint;
    
    BOOL isCollision = NO;
    
    if(direction == 0)
    {
        distance = maxY - self.position.y;
        countPointsInDistance = distance / 25;
        if(countPointsInDistance == 0)
        {
            currentDistance = 0;
        }
        else
        {
            currentDistance = (arc4random() % (countPointsInDistance)) + 1;
            
            for(int i = 1; i <= currentDistance; i++)
            {
                CGPoint point = CGPointMake(self.position.x, self.position.y + i * 25);
                
                if([gameLayer checkWaterPoolcollisionWithPoint: point])
                {
                    CCLOG(@"OLOLO");
                    isCollision = YES;
                }
            }
        }
        if(!isCollision)
        {
            dogPoint = CGPointMake(self.position.x, self.position.y + currentDistance * 25);
        }
    }
    if(direction == 1)
    {
        distance = self.position.y - minY;
        countPointsInDistance = distance / 25;
        if(countPointsInDistance == 0)
        {
            currentDistance = 0;
        }
        else
        {
            currentDistance = (arc4random() % (countPointsInDistance)) + 1;
            
            for(int i = 1; i <= currentDistance; i++)
            {
                CGPoint point = CGPointMake(self.position.x, self.position.y - i * 25);
                
                if([gameLayer checkWaterPoolcollisionWithPoint: point])
                {
                    CCLOG(@"OLOLO");
                    isCollision = YES;
                }
            }
        }
        if(!isCollision)
        {
            dogPoint = CGPointMake(self.position.x, self.position.y - currentDistance * 25);
        }
    }
    if(direction == 2)
    {
        distance = self.position.x - minX;
        countPointsInDistance = distance / 25;
        if(countPointsInDistance == 0)
        {
            currentDistance = 0;
        }
        else
        {
            currentDistance = (arc4random() % (countPointsInDistance)) + 1;
            
            for(int i = 1; i <= currentDistance; i++)
            {
                CGPoint point = CGPointMake(self.position.x - (i * 25), self.position.y);
                
                CCLOG(@"I: %i pointX %f pointY %f", i, point.x, point.y);
                
                if([gameLayer checkWaterPoolcollisionWithPoint: point])
                {
                    CCLOG(@"OLOLO");
                    isCollision = YES;
                }
            }
        }
        if(!isCollision)
        {
            dogPoint = CGPointMake(self.position.x - currentDistance * 25, self.position.y);
        }
    }
    if(direction == 3)
    {
        distance = maxX - self.position.x;
        countPointsInDistance = distance / 25;
        if(countPointsInDistance == 0)
        {
            currentDistance = 0;
        }
        else
        {
            currentDistance = (arc4random() % (countPointsInDistance)) + 1;
            
            for(int i = 1; i <= currentDistance; i++)
            {
                CGPoint point = CGPointMake(self.position.x + i * 25, self.position.y);
                
                if([gameLayer checkWaterPoolcollisionWithPoint: point])
                {
                    CCLOG(@"OLOLO");
                    isCollision = YES;
                }
            }
        }
        if(!isCollision)
        {
            dogPoint = CGPointMake(self.position.x + currentDistance * 25, self.position.y);
        }
    }
    
    if(isCollision) // Тут надо организовать доп функцию, чтобы можно было проверять колизии с бассейном
    {
        [self walk];
    }
    else
    {
        [self moveDog: dogPoint WithDirection: direction AndDistance: currentDistance];
    }
    
    
}

- (void) moveDog: (CGPoint) nextPoint WithDirection: (NSInteger) direction AndDistance: (NSInteger) distance
{
    CCLOG(@"Self.positionX %f position Y %f", nextPoint.x, nextPoint.y);
    
    float timeOfAction;
    float delayTime = (arc4random() % 20) / 10;
    
    if(delayTime < 0.5)
    {
        delayTime = 0.5;
    }
    
    timeOfAction = distance * 0.5;
    
    if(direction == 0)
    {
        [self moveUpAnimation];
    }
    if(direction == 1)
    {
        [self moveDownAnimation];
    }
    if(direction == 2)
    {
        [self moveLeftAnimation];
    }
    if(direction == 3)
    {
        [self moveRightAnimation];
    }
    
    [self runAction:
                      [CCSequence actions:
                                    [CCMoveTo actionWithDuration: timeOfAction
                                                        position: ccp(nextPoint.x, nextPoint.y)],
                                    [CCCallFunc actionWithTarget: self
                                                        selector: @selector(stopMoveAnimation)],
                                    [CCDelayTime actionWithDuration: delayTime],
                                    [CCCallFunc actionWithTarget: self
                                                        selector: @selector(walk)],
                                    nil
                      ]
    ];
}


- (void) stopMoveAnimation
{
    [dogSprite stopAllActions];
}

- (void) moveRightAnimation
{
    [dogSprite stopAllActions];
    
    [dogSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"dog_right_"]
                                 ]
             ]
     ];
}

- (void) moveLeftAnimation
{
    [dogSprite stopAllActions];
    
    [dogSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"dog_left_"]
                                 ]
             ]
     ];
}

- (void) moveUpAnimation
{
    [dogSprite stopAllActions];
    
    [dogSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"dog_up_"]
                                 ]
             ]
     ];
}

- (void) moveDownAnimation
{
    [dogSprite stopAllActions];
    
    [dogSprite runAction:
            [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:
                                        [[CCAnimationCache sharedAnimationCache] animationByName: @"dog_down_"]
                                 ]
             ]
     ];
}

- (void) poo
{
    if(self.position.x <= 350 && self.position.x >= 50 && self.position.y <= 225 && self.position.y >= 25)
    {
        Poo *poo = [[[Poo alloc] init] autorelease];
        poo.position = ccp(self.position.x, self.position.y + 12);
        
        [gameLayer.pooArray addObject: poo];
        [gameLayer.objectsArray addObject: poo];
        
        [gameLayer addChild: poo z: zPoo];
        
    }
}

- (void) runToPoint: (CGPoint) escapePoint andDirection: (NSInteger) direction AndReturnPoint: (CGPoint) returnPoint
{
    [self runAction:
                [CCSequence actions:
                                [CCMoveTo actionWithDuration: 4
                                                    position: escapePoint],
                                [CCDelayTime actionWithDuration: 2],
                                [CCCallBlock actionWithBlock:^(id sender){
                                                                            NSInteger distance = fabs(escapePoint.x - returnPoint.x) / 25;
                                                                            NSInteger dir;
                    
                                                                            if(direction == 0)
                                                                            {
                                                                                dir = 3;
                                                                            }
                                                                            if(direction == 2)
                                                                            {
                                                                                dir = 2;
                                                                            }
                    
                                                                            [self runAction:
                                                                                        [CCSequence actions:
                                                                                                    [CCCallBlock actionWithBlock:^(id sender){
                                                                                            [self moveDog: returnPoint WithDirection: dir AndDistance: distance]; }],
                                                                                         
                                                                                         [CCCallBlock actionWithBlock:^(id sender) {self.isRun = NO;}],
                                                                                    
                                                                                         nil]];
                                                                                
                                                                         }],
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


@end
