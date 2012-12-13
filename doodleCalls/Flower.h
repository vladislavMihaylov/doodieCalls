//
//  Rose.h
//  doodleCalls
//
//  Created by Vlad on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface Flower: CCNode
{
    GameLayer *gameLayer;
    
    CCSprite *flowerSprite;
    
    NSInteger type;
}

+ (Flower *) create;

- (void) updateFlower;
- (void) tapFlower;

@property (nonatomic, assign) CCSprite *flowerSprite;
@property (nonatomic, assign) GameLayer *gameLayer;

@end
