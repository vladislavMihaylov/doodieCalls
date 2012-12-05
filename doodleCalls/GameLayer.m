//
//  GameLayer.m
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

@synthesize guiLayer;

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    GameLayer *layer = [GameLayer node];
    
    GuiLayer *gui = [GuiLayer node];

    [scene addChild: layer];
    [scene addChild: gui];
    
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
        gameBatch = [CCSpriteBatchNode batchNodeWithFile: @"game_atlas.png"];
        [self addChild: gameBatch];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        batchNode = [CCSpriteBatchNode batchNodeWithFile: @"bg_atlas.png"];
        [self addChild: batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bg_atlas.plist"];
        
        CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName: @"BG.png"];
        backgroundSprite.position = ccp(240, 160);
        [self addChild: backgroundSprite];
        
        CCSprite *lamnMower = [CCSprite spriteWithSpriteFrameName: @"smallSide0.png"];
        lamnMower.position = ccp(100, 100);
        [self addChild: lamnMower];
    }
    
    return self;
}

@end
