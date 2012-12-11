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
//#import "Mower.h"

@class Mower;
@class GardenBed;

@interface GameLayer : CCLayer
{
    GuiLayer *guiLayer;
    
    Mower *mower;
    GardenBed *gardenBed;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatch;
    
    NSMutableArray *pooArray;
}

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel;

- (void) addGrassToPoint: (CGPoint) position;

@property (nonatomic, assign) GuiLayer *guiLayer;

@end
