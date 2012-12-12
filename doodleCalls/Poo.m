//
//  Poo.m
//  doodleCalls
//
//  Created by Vlad on 11.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Poo.h"


@implementation Poo

@synthesize tap;
@synthesize pooSprite;
@synthesize collised;

+ (Poo *) create
{
    Poo *poo = [[[Poo alloc] init] autorelease];
    
    return poo;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        pooSprite = [CCSprite spriteWithFile: @"poo.png"];
        //pooSprite.scale = 0.4;
        [self addChild: pooSprite];
        
        tap = NO;
        collised = NO;
    }
    
    return self;
}

-(BOOL) isTapped: (CGPoint) location
{
    float Ax = pooSprite.contentSize.width / 2;
    float Ay = pooSprite.contentSize.height / 2;
    float Tx = fabs(self.position.x - location.x);
    float Ty = fabsf(self.position.y - location.y);
    
    BOOL result = Tx <= Ax && Ty <= Ay;
    
    return result;
}

@end
