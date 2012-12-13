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
}

+ (Dog *) create;

- (void) walk;

- (void) walk;
- (void) poo;

@property (nonatomic, assign) GameLayer *gameLayer;

@end
