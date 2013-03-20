//
//  GuiLayer.m
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GuiLayer.h"
#import "GameLayer.h"
#import "SelectLevelLayer.h"

#import "GameConfig.h"
#import "Settings.h"
#import "SimpleAudioEngine.h"

@implementation GuiLayer

@synthesize gameLayer;

- (void) dealloc
{
    [heartsArray release];
    
    [super dealloc];
}

- (id) initWithLevel: (NSInteger) currentLevel
{
    if(self = [super init])
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect: @"coin.mp3"];
        
        curLvl = currentLevel;
        
        heartsArray = [[NSMutableArray alloc] init];
        
        batchNode = [CCSpriteBatchNode batchNodeWithFile: @"bg_atlas.png"];
        [self addChild: batchNode z: zMenuBg];
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
        [self addChild: scoreLabel z: zScoreBoard + 1];
        
        for (int i = 0; i < 1; i++)
        {
            CCSprite *heart = [CCSprite spriteWithFile: @"heart.png"];
            heart.position = ccp(170, 300);
            heart.scale = 0.8;
            [heartsArray addObject: heart];
            [self addChild: heart z: 1 tag: kHeartTag];
        }
        
        
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Label & hearts

- (void) updateScoreLabel: (NSInteger) currentScore
{
    scoreLabel.string = [NSString stringWithFormat: @"%i", currentScore];
}

- (void) removeHeart
{
    [heartsArray removeLastObject];
    
    [self removeChildByTag: kHeartTag cleanup: YES];
    
    if([heartsArray count] == 0)
    {
        [self showGameOverMenu];
    }
}

- (void) reloadHearts
{
    for (int i = 0; i < [heartsArray count]; i++)
    {
        [self removeChildByTag: kHeartTag cleanup: YES];
    }
    
    [heartsArray removeAllObjects];
    
    for (int i = 0; i < 1; i++)
    {
        CCSprite *heart = [CCSprite spriteWithFile: @"heart.png"];
        heart.position = ccp(170, 300);
        heart.scale = 0.8;
        [heartsArray addObject: heart];
        [self addChild: heart z: 1 tag: kHeartTag];
    }
}

#pragma mark -
#pragma mark Menus

- (void) showPauseMenu
{
    pauseBtn.isEnabled = NO;
    
    [gameLayer pause];
    
    CCMenuItemImage *playBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithFile: @"btnPlay0.png"]
                                                      selectedSprite: [CCSprite spriteWithFile: @"btnPlay1.png"]
                                                              target: self
                                                            selector: @selector(play)
                               ];
    
    CCMenuItemImage *restartBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay0.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay1.png"]
                                                                 target: self
                                                               selector: @selector(restart)
                                  ];
    
    CCMenuItemImage *exitBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel0.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel1.png"]
                                                              target: self
                                                            selector: @selector(backToSelectMenu)
                               ];
    
    playBtn.position = ccp(330, 110);
    restartBtn.position = ccp(270, 110);
    exitBtn.position = ccp(150, 110);
    
    CCSprite *soundOnBtn = [CCSprite spriteWithSpriteFrameName: @"btnSoundon.png"];
    CCSprite *soundOffBtn = [CCSprite spriteWithSpriteFrameName: @"btnsoundoff.png"];
    CCSprite *select = [CCSprite spriteWithFile: @"icon.png"];
    
    CCMenuItemImage *on = [CCMenuItemImage itemWithNormalSprite: soundOnBtn selectedSprite: select];
    CCMenuItemImage *off = [CCMenuItemImage itemWithNormalSprite: soundOffBtn selectedSprite: select];
    
    soundMenu = [CCMenu menuWithItems: nil];
    soundMenu.position = ccp(0, 320);
    [self addChild: soundMenu z: zMenuButtons];
    
    if ([Settings sharedSettings].soundLevel == 1)
    {
        CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundMode) items: on, off, nil];
        difficulty.position = ccp(210, 110);
        [soundMenu addChild:difficulty];
    }
    else if ([Settings sharedSettings].soundLevel == 2)
    {
        CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundMode) items: off, on, nil];
        difficulty.position = ccp(210, 110);
        [soundMenu addChild:difficulty];
    }
    
    pauseMenu = [CCMenu menuWithItems: playBtn, restartBtn, exitBtn, nil];
    pauseMenu.position = ccp(0, kGameHeight);
    
    [self addChild: pauseMenu z: zMenuButtons];
    
    [pauseMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(pauseMenu.position.x, 0)
                                        ]
                    ]
    ];
    
    [soundMenu runAction:
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
    pauseBtn.isEnabled = NO;
    
    [gameLayer pause];
    
    CCMenuItemImage *restartBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay0.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay1.png"]
                                                                 target: self
                                                               selector: @selector(restart)
                                  ];
    
    CCMenuItemImage *exitBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel0.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel1.png"]
                                                              target: self
                                                            selector: @selector(backToSelectMenu)
                               ];
    
    restartBtn.position = ccp(300, 110);
    exitBtn.position = ccp(180, 110);
    
    CCSprite *soundOnBtn = [CCSprite spriteWithSpriteFrameName: @"btnSoundon.png"];
    CCSprite *soundOffBtn = [CCSprite spriteWithSpriteFrameName: @"btnsoundoff.png"];
    CCSprite *select = [CCSprite spriteWithFile: @"icon.png"];
    
    CCMenuItemImage *on = [CCMenuItemImage itemWithNormalSprite: soundOnBtn selectedSprite: select];
    CCMenuItemImage *off = [CCMenuItemImage itemWithNormalSprite: soundOffBtn selectedSprite: select];
    
    soundMenu = [CCMenu menuWithItems: nil];
    soundMenu.position = ccp(0, 320);
    [self addChild: soundMenu z: zMenuButtons];
    
    if ([Settings sharedSettings].soundLevel == 1)
    {
        CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundMode) items: on, off, nil];
        difficulty.position = ccp(240, 110);
        [soundMenu addChild:difficulty];
    }
    else if ([Settings sharedSettings].soundLevel == 2)
    {
        CCMenuItemToggle *difficulty = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundMode) items: off, on, nil];
        difficulty.position = ccp(240, 110);
        [soundMenu addChild:difficulty];
    }
    
    pauseMenu = [CCMenu menuWithItems: restartBtn, exitBtn, nil];
    pauseMenu.position = ccp(0, kGameHeight);
    
    [self addChild: pauseMenu z: zMenuButtons];
    
    [pauseMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(pauseMenu.position.x, 0)
                                        ]
                    ]
    ];
    
    [soundMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(pauseMenu.position.x, 0)
                                        ]
                    ]
    ];
    
    [gameOverMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, GameCenterY)
                                        ]
                    ]
    ];
}

- (void) showSucceedMenu
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"coin.mp3"];
    
    CCMenuItemImage *nextBtn;
    
    if(curLvl == [Settings sharedSettings].openedLevels && [Settings sharedSettings].openedLevels <= 10)
    {
        [Settings sharedSettings].openedLevels++;
        [[Settings sharedSettings] save];
        
    }
    
    pauseBtn.isEnabled = NO;
    
    [gameLayer pause];
    
    CCMenuItemImage *restartBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay0.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnReplay1.png"]
                                                                 target: self
                                                               selector: @selector(restart)
                                  ];
    
    CCMenuItemImage *exitBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel0.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnLevel1.png"]
                                                              target: self
                                                            selector: @selector(backToSelectMenu)
                               ];
    
    
    if(curLvl < 10)
    {
        nextBtn = [CCMenuItemImage itemWithNormalSprite: [CCSprite spriteWithSpriteFrameName: @"btnNext0.png"]
                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"btnNext1.png"]
                                                 target: self
                                               selector: @selector(loadNextLevel)
                   ];
        
        nextBtn.position = ccp(300, 110);
        
        restartBtn.position = ccp(240, 110);
        exitBtn.position = ccp(180, 110);
        
        pauseMenu = [CCMenu menuWithItems: restartBtn, exitBtn, nextBtn, nil];
    }
    else
    {
        restartBtn.position = ccp(270, 110);
        exitBtn.position = ccp(210, 110);
        
        pauseMenu = [CCMenu menuWithItems: restartBtn, exitBtn, nil];
    }
    
    pauseMenu.position = ccp(0, kGameHeight);
    
    [self addChild: pauseMenu z: zMenuButtons];
    
    [pauseMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(pauseMenu.position.x, 0)
                                        ]
                    ]
    ];
    
    [succeedMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, GameCenterY)
                                        ]
                    ]
    ];
}

#pragma mark -
#pragma mark Menus methods

- (void) soundMode
{
    if ([Settings sharedSettings].soundLevel == 1)
    {
        [Settings sharedSettings].soundLevel = 2;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume: 0];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume: 0];
    }
    else
    {
        [Settings sharedSettings].soundLevel = 1;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume: 1];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume: 1];
    }
    
    [[Settings sharedSettings] save];
    
    
    CCLOG(@"%i", [Settings sharedSettings].soundLevel);
}

- (void) play
{
    pauseBtn.isEnabled = YES;
    
    [gameLayer unPause];
    
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: soundMenu cleanup: YES];
    
    [pauseMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
                                        ]
                    ]
    ];
    
    [soundMenu runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(soundMenu.position.x, 320)
                                        ]
                    ]
    ];

}

- (void) restart
{
    [self reloadHearts];
    
    pauseBtn.isEnabled = YES;
    
    [gameLayer restart: curLvl];
    
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: soundMenu cleanup: YES];
    
    [pauseMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
                                        ]
                    ]
    ];
    
    [gameOverMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
                                        ]
                    ]
    ];
    
    [succeedMenuBg runAction:
                    [CCEaseBackInOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.5
                                                            position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
                                        ]
                    ]
    ];
}

- (void) backToSelectMenu
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1 scene: [SelectLevelLayer scene]]];
}

- (void) loadNextLevel
{
    curLvl += 1;
    
    [gameLayer startLevel: curLvl];
    
    [self reloadHearts];
    
    pauseBtn.isEnabled = YES;
    
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: soundMenu cleanup: YES];
    
    [pauseMenuBg runAction:
     [CCEaseBackInOut actionWithAction:
      [CCMoveTo actionWithDuration: 0.5
                          position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
       ]
      ]
     ];
    
    [gameOverMenuBg runAction:
     [CCEaseBackInOut actionWithAction:
      [CCMoveTo actionWithDuration: 0.5
                          position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
       ]
      ]
     ];
    
    [succeedMenuBg runAction:
     [CCEaseBackInOut actionWithAction:
      [CCMoveTo actionWithDuration: 0.5
                          position: ccp(GameCenterX, kGameHeight + (kGameHeight / 2))
       ]
      ]
     ];
}

@end
