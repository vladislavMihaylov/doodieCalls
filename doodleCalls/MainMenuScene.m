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

@implementation MainMenuScene

- (void) pressedPlay: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: [SelectLevelLayer scene]]];
}

- (void) pressedShop: (id) sender
{
    CCScene* shopScene = [CCBReader sceneWithNodeGraphFromFile: @"ShopMenuScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: shopScene]];}

- (void) soundMode
{
    
}

- (void) sendTweet
{
    
}

- (void) sendFB
{
    
}

@end
