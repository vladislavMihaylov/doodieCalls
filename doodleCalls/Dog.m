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
    NSString *path = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"level%i", curLevel] ofType: @"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];                       // делаем Dictionary из файла plist
    
    NSString *pointsString = [NSString stringWithString: [dict valueForKey: @"path"]];            // берём строку с координатами
    
    NSArray *coordinats = [pointsString componentsSeparatedByString: @"/"];                       // получаем массив с координатами
    
    NSInteger minX = [[coordinats objectAtIndex: 0] integerValue];
    NSInteger maxX = [[coordinats objectAtIndex: (coordinats.count - 2)] integerValue];
    
    NSInteger minY = [[coordinats objectAtIndex: (coordinats.count - 1)] integerValue];
    NSInteger maxY = [[coordinats objectAtIndex: 1] integerValue];
    
    NSInteger movementX;
    NSInteger movementY;
    
    movementX = (arc4random() % (maxX - minX)) + minX;
    movementY = (arc4random() % (maxY - minY)) + minY;
    
    CGPoint dogPoint = CGPointMake(movementX, movementY);
    
    if([gameLayer checkWaterPoolcollisionWithPoint: dogPoint]) // Тут надо организовать доп функцию, чтобы можно было проверять колизии с бассейном
    {
        [self walk];
    }
    else
    {
        [self moveDog: dogPoint];
    }
    
    
}

- (void) moveDog: (CGPoint) nextPoint
{
    float timeOfAction;
    float delayTime = (arc4random() % 20) / 10;
    
    if(delayTime < 0.5)
    {
        delayTime = 0.5;
    }
    
    if([self getDirection])
    {
        nextPoint.x = self.position.x;
        
        if((nextPoint.y - self.position.y) > 0)
        {
            [self moveUpAnimation];
        }
        else
        {
            [self moveDownAnimation];
        }
        
        timeOfAction = fabs(nextPoint.y - self.position.y) / 70;
        
        if(timeOfAction < 1)
        {
            timeOfAction = 1;
        }
    }
    else
    {
        nextPoint.y = self.position.y;
        
        if((nextPoint.x - self.position.x) > 0)
        {
            [self moveRightAnimation];
        }
        else
        {
            [self moveLeftAnimation];
        }
        
        timeOfAction = fabs(nextPoint.x - self.position.x) / 70;
        
        if(timeOfAction < 1)
        {
            timeOfAction = 1;
        }
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

- (NSInteger) getDirection
{
    return arc4random() % 2;
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
    if(self.isRun == NO)
    {
        Poo *poo = [[[Poo alloc] init] autorelease];
        poo.position = self.position;
        
        [gameLayer.pooArray addObject: poo];
        [gameLayer.objectsArray addObject: poo];
        
        [gameLayer addChild: poo z: zPoo];
        
    }
}

- (void) runToPoint: (CGPoint) escapePoint andDirection: (NSInteger) direction
{
    [self runAction:
                [CCSequence actions:
                                [CCMoveTo actionWithDuration: 4
                                                    position: escapePoint],
                                [CCDelayTime actionWithDuration: 2],
                                [CCCallFunc actionWithTarget: self selector: @selector(switchRunStatus)],
                                nil
                ]
    ];
    
    if(direction == 0)
    {
        [self moveUpAnimation];
    }
    if(direction == 1)
    {
        [self moveDownAnimation];
    }
}

- (void) switchRunStatus
{
    self.isRun = NO;
    [self walk];
}


@end
