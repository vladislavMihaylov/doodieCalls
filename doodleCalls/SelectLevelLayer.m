//
//  SelectLevelLayer.m
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectLevelLayer.h"
#import "MainMenuScene.h"
#import "GameLayer.h"

#import "cocos2d.h"
#import "CCBReader.h"
#import "Settings.h"

@implementation SelectLevelLayer

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    SelectLevelLayer *layer = [SelectLevelLayer node];
    
    [scene addChild: layer];
    
    return scene;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {        
        batchNode = [CCSpriteBatchNode batchNodeWithFile: @"bg_atlas.png"]; 
        [self addChild: batchNode]; 
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bg_atlas.plist"];
        
        LevelsBatch = [CCSpriteBatchNode batchNodeWithFile: @"level_atlas.png"];
        [self addChild: LevelsBatch];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"level_atlas.plist"];
        
        
        background = [CCSprite spriteWithSpriteFrameName: @"BG.png"];  
        background.position = ccp(240, 170);
        background.scaleY = 1.4;
        [batchNode addChild: background z:1];
        
        
        backBtn = [CCSprite spriteWithSpriteFrameName: @"back1.png"];
        backBtnOn = [CCSprite spriteWithSpriteFrameName: @"back0.png"];
        
        
        
        CCMenuItemImage *back = [CCMenuItemImage itemWithNormalSprite: backBtn
                                                       selectedSprite: backBtnOn
                                                               target: self
                                                             selector: @selector(backInMainMenu)
                                 ];
        
        back.position = ccp (70, 30);
        
        backMenu = [CCMenu menuWithItems: back, nil];
        backMenu.position = ccp(0, -30);

        [self addChild: backMenu];
        
        [backMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                [CCMoveTo actionWithDuration: 1
                                                    position: ccp(0, 0)
                                 ]
                     ]
         ];
        
        openedLevels = [Settings sharedSettings].openedLevels;
        
        [self createLevelsMenu];
        
    }
    
    return self;
}

- (void) createLevelsMenu
{
    CCMenu *levelsMenu = [CCMenu menuWithItems: nil];
    
    for (int i = 0; i < 10; i++)
    {
        CCSprite *levelSprite;
        CCSprite *selectedLevelSprite;
        BOOL isActive;
        
        if (i < openedLevels)
        {
            levelSprite = [CCSprite spriteWithSpriteFrameName: @"level0.png"];
            selectedLevelSprite = [CCSprite spriteWithSpriteFrameName: @"level1.png"];
            isActive = YES;
        }
        else
        {
            levelSprite = [CCSprite spriteWithSpriteFrameName: @"levelLock.png"];
            selectedLevelSprite = [CCSprite spriteWithSpriteFrameName: @"levelLock.png"];
            isActive = NO;
        }
    
        CCMenuItemImage *item = [CCMenuItemImage itemWithNormalSprite: levelSprite
                                                       selectedSprite: selectedLevelSprite
                                                               target: self
                                                             selector: @selector(loadLevel:)
                                 ];
        
        item.isEnabled = isActive;
        item.tag = i + 1;
        
        if (isActive)
        {
            CCLabelTTF *numberOfLevel = [CCLabelTTF labelWithString: [NSString stringWithFormat: @"%i", i + 1]
                                                           fontName: @"Arial"
                                                           fontSize: 20
                                         ];
        
            numberOfLevel.position = ccp(levelSprite.contentSize.width / 2, levelSprite.contentSize.height * 0.6);
            [item addChild: numberOfLevel];
        }
        
        [levelsMenu addChild: item];
    }

    NSNumber *countColumns = [NSNumber numberWithInt: 5];
    
    levelsMenu.position = ccp(240, 380);
    
    [levelsMenu alignItemsInColumns: countColumns, countColumns, nil];
    
    [self addChild: levelsMenu];
    
    [levelsMenu runAction:
                [CCEaseBackInOut actionWithAction:
                            [CCMoveTo actionWithDuration: 1
                                                position: ccp(240, 180)
                             ]
                 ]
     ];
}

- (void) loadLevel: (CCMenuItemImage *) sender
{
    [[CCDirector sharedDirector] replaceScene:
                                        [CCTransitionFade transitionWithDuration: 0.5
                                                                           scene: [GameLayer sceneWithLevelNumber: sender.tag]
                                         ]
     ];
}


- (void) backInMainMenu
{
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile: @"MainMenuScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: mainScene]];
}

@end
