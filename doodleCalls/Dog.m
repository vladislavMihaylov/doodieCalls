//
//  Dog.m
//  doodleCalls
//
//  Created by Vlad on 12.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Dog.h"


@implementation Dog

+ (Dog *) create
{
    Dog *dog = [[[Dog alloc] init] autorelease];
    
    return dog;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (void) walking
{
    
}

- (void) toShit
{
    
}


@end
