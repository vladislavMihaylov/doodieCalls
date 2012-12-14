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
@class Ball;
@class Boy;
@class Cat;
@class Kennel;

@interface GameLayer : CCLayer
{
    GuiLayer *gui;
    
    Mower *mower;
    GardenBed *gardenBed;
    Dog *dog;
    WaterPool *waterPool;
    Flower *flower;
    Ball *ball;
    Boy *boy;
    Cat *cat;
    Kennel *kennel;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatch;
    
    CCSprite *scoreBoardSprite;
    
    CCLayerColor *blinkLayer;
    
    NSMutableArray *pooArray;
    NSMutableArray *ballsArray;
    NSMutableArray *objectsArray;
    
    NSMutableArray *objectsWithDynamicZ;
    
    NSInteger score;
}

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel;

- (void) addGrassToPoint: (CGPoint) position;
- (BOOL) checkWaterPoolcollisionWithPoint: (CGPoint) point;
- (void) addScoreFromFlower;
- (void) getCoordinatsForBall;

- (void) pause;
- (void) unPause;
- (void) gameOver;
- (void) restart;

@property (nonatomic, assign) GuiLayer *guiLayer;
@property (nonatomic, assign) NSMutableArray *pooArray;
@property (nonatomic, assign) NSMutableArray *objectsArray;

@end
