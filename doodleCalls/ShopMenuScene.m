//
//  ShopMenuScene.m
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopMenuScene.h"

#import "CCBReader.h"


@implementation ShopMenuScene

- (void) buyElement: (CCMenuItemImage *) sender
{
    CCLOG(@"Tag = %i", sender.tag);
}

- (void) backInMainMenu
{
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile: @"MainMenuScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: mainScene]];
}

@end
