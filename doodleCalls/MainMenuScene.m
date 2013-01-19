//
//  MainMenuScene.m
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "SelectLevelLayer.h"

#import "CCBReader.h"
#import "Settings.h"

#import "SimpleAudioEngine.h"

@implementation MainMenuScene

- (void) pressedPlay: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: [SelectLevelLayer scene]]];
}

- (void) pressedShop: (id) sender
{
    CCScene* shopScene = [CCBReader sceneWithNodeGraphFromFile: @"ShopMenuScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: shopScene]];
}

- (void) didLoadFromCCB
{
    
    CCLOG(@"I loaded %i ",[Settings sharedSettings].soundLevel);
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"bg.mp3" loop: YES];
    
    if ([Settings sharedSettings].soundLevel == 1)
    {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume: 1];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume: 0];
    }
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"game_atlas.plist"]];
    
    CCSprite *soundOnBtn = [CCSprite spriteWithSpriteFrameName: @"btnSoundon.png"];
    CCSprite *soundOffBtn = [CCSprite spriteWithSpriteFrameName: @"btnsoundoff.png"];
    CCSprite *select = [CCSprite spriteWithFile: @"icon.png"];
    
    CCMenuItemImage *on = [CCMenuItemImage itemWithNormalSprite: soundOnBtn selectedSprite: select];
    CCMenuItemImage *off = [CCMenuItemImage itemWithNormalSprite: soundOffBtn selectedSprite: select];
    
    CCMenu *difficultyMenu = [CCMenu menuWithItems: nil];
    difficultyMenu.position = ccp(0, 0);
    [self addChild:difficultyMenu];
    
    if ([Settings sharedSettings].soundLevel == 1)
    {
        CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundMode) items: on, off, nil];
        difficulty.position = ccp(50, 175);
        [difficultyMenu addChild:difficulty];
    }
    else if ([Settings sharedSettings].soundLevel == 2)
    {
        CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundMode) items: off, on, nil];
        difficulty.position = ccp(50, 175);
        [difficultyMenu addChild:difficulty];
    }
}

- (void) soundMode
{
    if ([Settings sharedSettings].soundLevel == 1)
    {
        [Settings sharedSettings].soundLevel = 2;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume: 0];
    }
    else
    {
        [Settings sharedSettings].soundLevel = 1;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume: 1];
    }
    
    [[Settings sharedSettings] save];
    
    
    CCLOG(@"%i", [Settings sharedSettings].soundLevel);
}

- (void) sendTweet
{
    
}

- (void) sendFB
{
    
}

@end
