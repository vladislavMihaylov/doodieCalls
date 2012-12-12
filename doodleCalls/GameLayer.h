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

@interface GameLayer : CCLayer
{
    GuiLayer *gui;
    
    Mower *mower;
    GardenBed *gardenBed;
    Dog *dog;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatch;
    
    CCSprite *scoreBoardSprite;
    
    NSMutableArray *pooArray;
    
    NSInteger score;
}

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel;

- (void) addGrassToPoint: (CGPoint) position;

@property (nonatomic, assign) GuiLayer *guiLayer;

@end
