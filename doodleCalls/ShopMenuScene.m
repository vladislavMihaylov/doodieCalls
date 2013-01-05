//
//  ShopMenuScene.m
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopMenuScene.h"

#import "CCBReader.h"

#import "Settings.h"

@implementation ShopMenuScene


- (void) dealloc
{
    [super dealloc];
    
    [valuesArray release];
}

- (void) buyElement: (CCMenuItemImage *) sender
{    
    if(sender.tag > 0)
    {
        if([[valuesArray objectAtIndex: sender.tag] integerValue] == 0)
        {
            [sender stopAllActions];
            
            NSMutableString *result = [NSMutableString stringWithString: @""];
            NSString *curChar = @"";
            
            for(int i = 0; i < 4; i++)
            {
                if(i != sender.tag)
                {
                    curChar = [valuesArray objectAtIndex: i];
                }
                else
                {
                    curChar = @"1";
                }
                
                [result appendString: curChar];
            }
            
            CCLOG(@"result = %@", result);
            NSInteger res = [result integerValue];
            
            [Settings sharedSettings].money -= sender.tag * 1000;
            moneyLabel.string = [NSString stringWithFormat: @"Money: %i", [Settings sharedSettings].money];
            [Settings sharedSettings].currentMower = sender.tag;
            [Settings sharedSettings].availableMowers = res;
            [[Settings sharedSettings] save];
        }
        else
        {
            
        }
    }
    
    [Settings sharedSettings].currentMower = sender.tag;
    [[Settings sharedSettings] save];
    
    [self updateButtonsState];
}

- (void) didLoadFromCCB
{
    //[Settings sharedSettings].money = 0;
    //[Settings sharedSettings].availableMowers = 1000;
    //[Settings sharedSettings].currentMower = 0;
    //[[Settings sharedSettings] save];
    
    moneyLabel = [CCLabelTTF labelWithString:
                                        [NSString stringWithFormat: @"Money: %i", [Settings sharedSettings].money ]
                                                          fontName: @"Helvetica"
                                                          fontSize: 30
                  ];
    
    moneyLabel.position = ccp(270, 30);
    moneyLabel.anchorPoint = ccp(0, 0.5);
    [self addChild: moneyLabel];
    
    
    
    CCArray *arr = [self children];
    for(CCNode *cur in arr)
    {
        if(cur.tag == 5)
        {
            items = [cur children];
            
            [self updateButtonsState];
        }
    }
}

- (void) updateButtonsState
{
    CCLOG(@"curItemInSettings %i", [Settings sharedSettings].currentMower);
    
    combination = [NSString stringWithFormat: @"%i", [Settings sharedSettings].availableMowers];
    
    valuesArray = [[NSMutableArray alloc] initWithCapacity: [combination length]];
    
    [valuesArray retain];
    
    for (int i = 0; i < 4; i++)
    {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [combination characterAtIndex:i]];
        
        [valuesArray addObject: ichar];
        
        CCLOG(@"char %i = %@", i, ichar);
    }
    
    for(CCMenuItemImage *curItem in items)
    {
        if(curItem.tag == [Settings sharedSettings].currentMower)
        {
            curItem.scale = 1.05;
        }
        else
        {
            curItem.scale = 1.0;
        }
        
        curItem.isEnabled = YES;
        curItem.opacity = 255;
        //[curItem stopAllActions];
        
        if(curItem.tag > 0)
        {
            if([[valuesArray objectAtIndex: curItem.tag] integerValue] == 0)
            {
                if([Settings sharedSettings].money >= curItem.tag * 1000)
                {
                    curItem.isEnabled = YES;
                    curItem.opacity = 230;
                    
                    [curItem runAction:
                                [CCRepeatForever actionWithAction:
                                                            [CCSequence actions:
                                                                            [CCScaleTo actionWithDuration: 0.2
                                                                                                    scale: 1.03],
                                                                            [CCScaleTo actionWithDuration: 0.2
                                                                                                    scale: 1],
                                                             nil]
                                 ]
                     ];
                }
                else
                {
                    curItem.isEnabled = NO;
                    curItem.opacity = 200;
                    curItem.scale = 0.9;
                }
            }
            else
            {
                
                
            }
        }
    }
}

- (void) backInMainMenu
{
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile: @"MainMenuScene.ccbi"];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: mainScene]];
}

@end
