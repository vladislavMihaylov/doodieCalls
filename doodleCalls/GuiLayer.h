//
//  GuiLayer.h
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface GuiLayer :CCLayer
{
    GameLayer *gameLayer;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatchNode;
    
    // Buttons
    
    CCSprite *pauseBtnSprite;
    CCSprite *pauseBtnSpriteOn;
    
    // BackGrounds
    
    CCSprite *pauseMenuBg;
    CCSprite *gameOverMenuBg;
    CCSprite *succeedMenuBg;
    
    // Menus
    
    CCMenuItemImage *pauseBtn;
    
    CCMenu *pauseMenu;
}

@property (nonatomic, assign) GameLayer *gameLayer;

@end
