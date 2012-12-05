//
//  SelectLevelLayer.h
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SelectLevelLayer : CCLayer
{
    
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *LevelsBatch;
    
    CCSprite *background;
    CCSprite *backBtn;
    CCSprite *backBtnOn;
    
    CCMenu *backMenu;
    
    NSInteger openedLevels;
    
}

+ (CCScene *) scene;

@end
