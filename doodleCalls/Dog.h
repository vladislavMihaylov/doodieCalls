//
//  Dog.h
//  doodleCalls
//
//  Created by Vlad on 12.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface Dog: CCNode
{
    GameLayer *gameLayer;
    
    CCSprite *dogSprite;
    
    BOOL isRun;
    
    float xPoo;
    float yPoo;
}

+ (Dog *) create;

//- (void) walk;

- (void) walk;
- (void) poo;

- (void) runToPoint: (CGPoint) escapePoint andDirection: (NSInteger) direction AndReturnPoint: (CGPoint) returnPoint;

@property (nonatomic, assign) GameLayer *gameLayer;
@property (nonatomic, assign) BOOL isRun;

@end
