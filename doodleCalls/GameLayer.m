//
//  GameLayer.m
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "Mower.h"

@implementation GameLayer

@synthesize guiLayer;

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel
{
    CCScene *scene = [CCScene node];
    
    GameLayer *layer = [[[GameLayer alloc] initWithLevel: numberOfLevel] autorelease];
    
    GuiLayer *gui = [GuiLayer node];

    [scene addChild: layer];
    [scene addChild: gui];
    
    return scene;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithLevel: (NSInteger) level
{
    if(self = [super init])
    {
        NSString *currentLevel = [NSString stringWithFormat: @"%i", level];
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"arrays" ofType: @"plist"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];                       // делаем Dictionary из файла plist
        
        NSString *pointsString = [NSString stringWithString: [dict valueForKey: currentLevel]];      // указываем ключ (номер стадии)
        
        NSArray *coordinats = [pointsString componentsSeparatedByString: @"/"];                       // получаем массив с координатами
        
        ///////////////////////////////////////////////////////////////////////
        
        gameBatch = [CCSpriteBatchNode batchNodeWithFile: @"game_atlas.png"];
        [self addChild: gameBatch];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        batchNode = [CCSpriteBatchNode batchNodeWithFile: @"bg_atlas.png"];
        [self addChild: batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bg_atlas.plist"];
        
        CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName: @"BG.png"];
        backgroundSprite.position = ccp(240, 160);
        [self addChild: backgroundSprite];
        
        mower = [Mower create];
        
        [self addChild: mower];
        
        [mower moveWithPath: coordinats];
    }
    
    return self;
}


@end
