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

@interface GameLayer : CCLayer
{
    GuiLayer *guiLayer;
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *gameBatch;
}

+(CCScene *) scene;

@property (nonatomic, assign) GuiLayer *guiLayer;

@end
