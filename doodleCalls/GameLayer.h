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

@interface GameLayer : CCLayer
{
    GuiLayer *guiLayer;
    
    Mower *mower;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatch;
}

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel;

@property (nonatomic, assign) GuiLayer *guiLayer;

@end
