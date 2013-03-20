//
//  Ball.m
//  doodleCalls
//
//  Created by Vlad on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "GameLayer.h"

@implementation Ball

@synthesize gameLayer;
@synthesize status;
@synthesize tap;
@synthesize ballTime;

+ (Ball *) create
{
    Ball *ball = [[[Ball alloc] init] autorelease];
    
    return ball;
}

- (void) dealloc
{
    
    [super dealloc];
}

- (id) init
{
    if(self  = [super init])
    {
        ballTime = 0;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        ballSprite = [CCSprite spriteWithSpriteFrameName: @"ball0.png"];
        
        [self addChild: ballSprite];
        
        CGSize spriteSize = [ballSprite contentSize];
        self.contentSize = spriteSize;
        
        status = inPool;
        tap = NO;
        self.visible = NO;
    }
    
    return self;
}

- (void) flyToPosition: (CGPoint) point
{
    status = inAir;
    self.visible = YES;
    
    CCLOG(@"pointX: %f PointY: %f", point.x, point.y);
    
    [self runAction: [CCSequence actions: [CCJumpTo actionWithDuration: 2 position: point height: 100 jumps: 1],
                                          [CCCallFunc actionWithTarget: self selector: @selector(setFieldStatus)],
                                          nil
                     ]
    ];
}

- (void) setFieldStatus
{
    status = onField;
}

- (NSInteger) getRandomNumberForBall // обозвать по-другому
{
    NSInteger rNum = arc4random() % 20;
    
    return rNum;
}

- (BOOL) isTapped: (CGPoint) location
{
    float Ax = ballSprite.contentSize.width + 5 / 2;
    float Ay = ballSprite.contentSize.height + 5 / 2;
    float Tx = fabs(self.position.x - location.x);
    float Ty = fabsf(self.position.y - location.y);
    
    BOOL result = Tx <= Ax && Ty <= Ay;
    
    return result;
}

@end
