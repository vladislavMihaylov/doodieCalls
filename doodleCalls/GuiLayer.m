//
//  GuiLayer.m
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GuiLayer.h"


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
        CCSprite *sprite = [CCSprite spriteWithFile: @"Icon.png"];
        sprite.position = ccp(440, 280);
        [self addChild: sprite];
    }
    
    return self;
}

@end
