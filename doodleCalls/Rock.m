//
//  Rock.m
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Rock.h"


@implementation Rock

+ (Rock *) create
{
    Rock *rock = [[[Rock alloc] init] autorelease];
    
    return rock;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        CCSprite *waterPool = [CCSprite spriteWithFile: @"Icon.png"];
        waterPool.position = ccp(0,0);
        //[self addChild: waterPool];
    }
    
    return self;
}

@end
