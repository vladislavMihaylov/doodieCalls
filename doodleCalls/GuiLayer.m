//
//  GuiLayer.m
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GuiLayer.h"
#import "GameLayer.h"

#import "GameConfig.h"

@implementation GuiLayer

@synthesize gameLayer;

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
        
        gameBatchNode = [CCSpriteBatchNode batchNodeWithFile: @"game_atlas.png"];
        [self addChild: gameBatchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
        
        pauseBtnSprite = [CCSprite spriteWithSpriteFrameName: @"pause0.png"];
        pauseBtnSpriteOn = [CCSprite spriteWithSpriteFrameName: @"pause1.png"];
        
        pauseMenuBg = [CCSprite spriteWithSpriteFrameName: @"pausedBG.png"];
        pauseMenuBg.position = ccp(GameCenterX, kGameHeight + (kGameHeight / 2));
        
        gameOverMenuBg = [CCSprite spriteWithSpriteFrameName: @"failedBG.png"];
        gameOverMenuBg.position = ccp(GameCenterX, kGameHeight + (kGameHeight / 2));
        
        succeedMenuBg = [CCSprite spriteWithSpriteFrameName: @"succeedBG.png"];
        succeedMenuBg.position = ccp(GameCenterX, kGameHeight + (kGameHeight / 2));
        
        [batchNode addChild: pauseMenuBg];
        [batchNode addChild: gameOverMenuBg];
        [batchNode addChild: succeedMenuBg];
        
        pauseBtn = [CCMenuItemImage itemWithNormalSprite: pauseBtnSprite
                                                           selectedSprite: pauseBtnSpriteOn
                                                                   target: self
                                                                 selector: @selector(showPauseMenu)
                                    ];
        
        pauseBtn.position = ccp(454, 290);
        
        CCMenu *guiMenu = [CCMenu menuWithItems: pauseBtn, nil];
        guiMenu.position = ccp(0, 0);
        [self addChild: guiMenu];
        
        scoreLabel = [CCLabelTTF labelWithString: @"0" fontName: @"Arial" fontSize: 16];
        scoreLabel.color = ccc3(0, 0, 0);
        scoreLabel.position = ccp(75, 300);
        [self addChild: scoreLabel];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Label 

- (void) updateScoreLabel: (NSInteger) currentScore
{
    CCLOG(@"Score %i", currentScore);
    scoreLabel.string = [NSString stringWithFormat: @"%i", currentScore];
}

#pragma mark -
#pragma mark Menus

- (void) showPauseMenu
{
    pauseBtn.isEnabled = NO;
    
    CCMenuItemImage *playBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay0.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay1.png"]
                                                              target: self
                                                            selector: @selector(play)
                               ];
    
    CCMenuItemImage *restartBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay0.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay1.png"]
                                  ];
    
    CCMenuItemImage *soundModeBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnSoundon.png"]
                                                           selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnsoundoff.png"]
                                    ];
    
    CCMenuItemImage *exitBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel0.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel1.png"]
                               ];
    
    playBtn.position = ccp(330, 110);
    restartBtn.position = ccp(270, 110);
    soundModeBtn.position = ccp(210, 110);
    exitBtn.position = ccp(150, 110);
    
    pauseMenu = [CCMenu menuWithItems: playBtn, restartBtn, soundModeBtn, exitBtn, nil];
    pauseMenu.position = ccp(0, kGameHeight);
    
    [self addChild: pauseMenu];
    
    [pauseMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(pauseMenu.position.x, 0)
                                        ]
                    ]
    ];
    
    [pauseMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, GameCenterY)
                                        ]
                    ]
    ];
}

- (void) showGameOverMenu
{
    
}

- (void) showSucceedMenu
{
    
}

#pragma mark -
#pragma mark Menus methods

- (void) play
{
    pauseBtn.isEnabled = YES;
    
    [pauseMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(pauseMenu.position.x, kGameHeight)
                                        ]
                    ]
    ];
    
    [pauseMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
                                        ]
                    ]
    ];
}

@end
