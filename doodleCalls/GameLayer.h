//
//  GameLayer.h
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GuiLayer.h"

@class Mower;
@class GardenBed;
@class Dog;
@class WaterPool;
@class Flower;

@interface GameLayer : CCLayer
{
    GuiLayer *gui;
    
    Mower *mower;
    GardenBed *gardenBed;
    Dog *dog;
    WaterPool *waterPool;
    Flower *flower;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatch;
    
    CCSprite *scoreBoardSprite;
    
    NSMutableArray *pooArray;
    
    NSInteger score;
}

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel;

- (void) addGrassToPoint: (CGPoint) position;
- (BOOL) checkWaterPoolcollisionWithPoint: (CGPoint) point;
- (void) addScoreFromFlower;

@property (nonatomic, assign) GuiLayer *guiLayer;
@property (nonatomic, assign) NSMutableArray *pooArray;

@end
